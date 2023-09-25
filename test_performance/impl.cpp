
#include "impl.h"
#include "vectorized.h"

string Timer::get_elapsed_time() const
{
    using std::chrono::duration_cast;

    Time end_time = Clock::now();
    size_t total_microseconds = duration_cast<Microseconds>(end_time - start_time).count();
    // size_t hours = total_miliseconds / (1000 * 60 * 60);
    // size_t minutes = (total_miliseconds / (1000 * 60)) % 60;
    // size_t seconds = (total_miliseconds / 1000) % 60;
    // size_t milliseconds = total_miliseconds & 1000;

    using namespace std;
    constexpr size_t WIDTH = 4;
    std::stringstream ss;
    ss << "Elapset time = " << total_microseconds / 1000000.0 << " sec\n";
    return ss.str();
};

void add_c_style(const Scalar *a, const Scalar *b, Scalar *c, Index N)
{
    for (Index i{0}; i < N; i++)
    {
        c[i] = a[i] * b[i];
    }
}

void add_std_vector(const vector<Scalar> &a, const vector<Scalar> &b, vector<Scalar> &c)
{
    for (Index i{0}; i < a.size(); i++)
    {
        c[i] = a[i] * b[i];
    }
}

void add_eigen_vector(const VectorX &a, const VectorX &b, VectorX &c)
{
    // c = a * b;

    for (Index i{0}; i < a.size(); i++)
    {
        c(i) = a(i) + b(i);
    }
}