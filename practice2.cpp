#include <iostream>
#include <locale>
using namespace std;
class MyArrayParent {
    protected:
        int capacity;
        int count;
        double ptr;
    public:
        MyArrayParent(int dimension=100){
            ptr = new double[dimension];
            capacity=dimension;
            count=0;
        }
        
        MyArrayParent(const MyArrayParent &a){
            ptr=new double[a.capacity];
            capacity=a.capacity;
            count=a.count;
            for (int i=0, i<count; i++){
                ptr[i]=a.ptr[i];
            }
        }
        ~MyArrayParent(){
            if(ptr!=NULL){
                delete[] ptr;
                ptr=NULL;
            }
        }
        
        MyArrayParent operator=(const MyArrayParent &a){
            if (this!=&a){
                if(capacity!=a.capacity){
                    delete ptr[];
                    ptr= new double[a.capacity];
                    capacity=a.capacity;
                }
            }
            count=a.count;
            for(i=0, i<count; i++){
                ptr[i]=a.ptr[i];
            }
            return this*;
        }
        
        double &operator[](int index){
            if (index>=0 && index<count){
                return ptr[index]
            }
            throw out_of_range("index out of range")
        }
        
        int IndexOf(double v) const{
            for (i=0, i<count, i++){
                if(ptr[i]==v){
                    return i;
                }
            }
            return -1;
        }
            void push(double value) {
        if (count < capacity) {
            ptr[count++] = value;
            }
        }

        void RemoveLastValue() {
            if (count > 0) {
                count--;
            }
        }
    
        void print() const {
            cout << "Array: [";
            for (int i = 0; i < count; i++) {
                cout << ptr[i];
                if (i != count - 1) {
                    cout << ", ";
                }
            }
            cout << "]" << endl;
        }
};

class MyArrayChild{
    public MyArrayParent {
        public:
        void RemoveAt(int x){
            if(x>=0 && x<count){
                for(i=index; i<count; i++){
                    ptr[i]=ptr[i+1];
                }
                count--;
            }
        }
        void InsertAt(double value, int index) {
            if (count < capacity && index >= 0 && index <= count) {
                for (int i = count; i > index; i--) {
                    ptr[i] = ptr[i - 1];
                }
                ptr[index] = value;
                count++;
            }
        }
        void shift(int n) const{
            MyArrayParent copyy(*this);
            for(i=0, i<count; i++){
                copyy.ptr[i]+=n;
            }
            return copyy;
        }
    }
};

class MySortedArray : 
    public MyArrayChild {
        public:
            // Конструкторы и деструкторы
            MySortedArray(int Dimension = 100){ 
                MyArrayChild(Dimension) 
            }
            // Перегрузка операций и другие функции
            // Перегруженный оператор добавления элемента
            void push(double value) override {
                // Если массив полон, расширяем его
                if (count >= capacity) {
                    double* temp = new double[2 * capacity];
                    for (int i = 0; i < count; i++) {
                        temp[i] = ptr[i];
                    }
                    delete[] ptr;
                    ptr = temp;
                    capacity *= 2;
                }
        
                // Находим место для вставки элемента, чтобы сохранить упорядоченность
                int index = 0;
                while (index < count && ptr[index] < value) {
                    index++;
                }
        
                // Сдвигаем элементы вправо, чтобы освободить место для нового элемента
                for (int i = count; i > index; i--) {
                    ptr[i] = ptr[i - 1];
                }
        
                // Вставляем новый элемент и увеличиваем счетчик
                ptr[index] = value;
                count++;
            }
        
            // Переопределение функции поиска
            int IndexOf(double value, bool bFindFromStart = true){
                int start = bFindFromStart ? 0 : count - 1;
                int end = bFindFromStart ? count : -1;
                int step = bFindFromStart ? 1 : -1;
        
                for (int i = start; i != end; i += step) {
                    if (ptr[i] == value) {
                        return i;
                    }
                }
                return -1; // Если элемент не найден
            }
        
            // Перегруженный оператор [] для доступа к элементам по индексу
            double& operator[](int index) {
                if (index >= 0 && index < count) {
                    return ptr[index];
                } else {
                    // Генерируем исключение, если индекс некорректный
                    throw std::out_of_range("Index out of range");
                }
    }
};
