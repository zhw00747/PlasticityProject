#pragma once

#include <chrono>
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <eigen3/Eigen/Dense>

using namespace std;
using Scalar = double;
using Index = uint32_t;
using VectorX = Eigen::VectorX<Scalar>;

class Timer
{
    using Clock = std::chrono::high_resolution_clock;
    using Time = std::chrono::_V2::system_clock::time_point;
    using Milliseconds = std::chrono::milliseconds;
    using Microseconds = std::chrono::microseconds;
    Time start_time; // Used for measuring time
public:
    void start_counter() { start_time = Clock::now(); }
    string get_elapsed_time() const;
};

void add_c_style(const Scalar *a, const Scalar *b, Scalar *c, Index N);

void add_std_vector(const vector<Scalar> &a, const vector<Scalar> &b, vector<Scalar> &c);

void add_eigen_vector(const VectorX &a, const VectorX &b, VectorX &c);