#include <iostream>
#include <fstream>
#include <pthread.h>
#include <queue>
#include <vector>
#include <random>
#include <unistd.h>

std::queue<int> task_portfolio; // Портфель задач: участки леса
pthread_mutex_t portfolio_mutex; // Мьютекс для защиты доступа к портфелю
bool winnie_found = false; // Флаг нахождения Винни-Пуха
std::ofstream output_file; // Файл для записи результатов

struct ThreadData {
    int swarm_id;
};

// Функция поиска Винни-Пуха на участке
bool search_for_winnie(int section_id) {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    static std::uniform_int_distribution<> dist(1, 100);

    usleep(100000); // Симуляция времени поиска
    int chance = dist(gen);
    return chance > 95; // Винни-Пух найден с вероятностью 5%
}

// Функция работы стаи пчел
void* bee_swarm(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    int swarm_id = data->swarm_id;

    while (true) {
        int section_id = -1;

        // Получение задания из портфеля
        pthread_mutex_lock(&portfolio_mutex);
        if (winnie_found) {
            pthread_mutex_unlock(&portfolio_mutex);
            output_file << "Swarm " << swarm_id << ": Winnie the Pooh has already been found. Returning to the hive.\n";
            std::cout << "Swarm " << swarm_id << ": Winnie the Pooh has already been found. Returning to the hive.\n";
            pthread_exit(nullptr);
        }
        if (!task_portfolio.empty()) {
            section_id = task_portfolio.front();
            task_portfolio.pop();
        }
        pthread_mutex_unlock(&portfolio_mutex);

        if (section_id == -1) {
            // Нет больше задач в портфеле
            pthread_exit(nullptr);
        }

        // Проверяем участок
        output_file << "Swarm " << swarm_id << " is searching section " << section_id << "...\n";
        std::cout << "Swarm " << swarm_id << " is searching section " << section_id << "...\n";

        if (search_for_winnie(section_id)) {
            pthread_mutex_lock(&portfolio_mutex);
            winnie_found = true;
            pthread_mutex_unlock(&portfolio_mutex);

            output_file << "Swarm " << swarm_id << " has found Winnie the Pooh in section " << section_id << "!\n";
            std::cout << "Swarm " << swarm_id << " has found Winnie the Pooh in section " << section_id << "!\n";
            pthread_exit(nullptr);
        } else {
            output_file << "Swarm " << swarm_id << " found nothing in section " << section_id << ". Returning to the hive.\n";
            std::cout << "Swarm " << swarm_id << " found nothing in section " << section_id << ". Returning to the hive.\n";
        }
    }
}

void print_usage(const char* program_name) {
    std::cout << "Usage: " << program_name << " [-f output_file] [-i input_file] [-s num_sections] [-n num_swarms]\n";
    std::cout << "  -f output_file : Specify output file for results\n";
    std::cout << "  -i input_file  : Specify input file with section IDs\n";
    std::cout << "  -s num_sections: Number of forest sections (ignored if -i is used)\n";
    std::cout << "  -n num_swarms  : Number of bee swarms\n";
}

int main(int argc, char* argv[]) {
    int num_sections = 20; // Количество участков леса по умолчанию
    int num_swarms = 5;    // Количество стай пчел по умолчанию
    std::string output_filename;
    std::string input_filename;

    // Обработка аргументов командной строки
    int opt;
    while ((opt = getopt(argc, argv, "f:i:s:n:")) != -1) {
        switch (opt) {
            case 'f':
                output_filename = optarg;
                break;
            case 'i':
                input_filename = optarg;
                break;
            case 's':
                num_sections = std::stoi(optarg);
                break;
            case 'n':
                num_swarms = std::stoi(optarg);
                break;
            default:
                print_usage(argv[0]);
                return 1;
        }
    }

    if (output_filename.empty()) {
        std::cerr << "Output file must be specified using -f option.\n";
        return 1;
    }

    output_file.open(output_filename);
    if (!output_file.is_open()) {
        std::cerr << "Failed to open output file: " << output_filename << "\n";
        return 1;
    }

    // Если указан файл ввода, читаем участки из него
    if (!input_filename.empty()) {
        std::ifstream input_file(input_filename);
        if (!input_file.is_open()) {
            std::cerr << "Failed to open input file: " << input_filename << "\n";
            return 1;
        }

        int section_id;
        while (input_file >> section_id) {
            task_portfolio.push(section_id);
        }
    } else {
        // Генерируем участки леса, если файл ввода не указан
        for (int i = 1; i <= num_sections; ++i) {
            task_portfolio.push(i);
        }
    }

    // Инициализация мьютекса
    pthread_mutex_init(&portfolio_mutex, nullptr);

    // Запускаем потоки для каждой стаи пчел
    std::vector<pthread_t> threads(num_swarms);
    std::vector<ThreadData> thread_data(num_swarms);

    for (int i = 0; i < num_swarms; ++i) {
        thread_data[i].swarm_id = i + 1;
        pthread_create(&threads[i], nullptr, bee_swarm, &thread_data[i]);
    }

    // Ожидаем завершения всех потоков
    for (auto& thread : threads) {
        pthread_join(thread, nullptr);
    }

    std::cout << "All bee swarms have returned to the hive.\n";
    output_file << "All bee swarms have returned to the hive.\n";

    // Очистка ресурсов
    pthread_mutex_destroy(&portfolio_mutex);
    output_file.close();

    return 0;
}
