# eigen_benchmark

This code measure computational times of C++ with Eigen.
For comparison, computational times of Fortran with netlib reference BLAS and LPACK are also measured.

## Content

- a.out : C++ with Eigen
- f.out : Fortran with netlib reference BLAS and LPACK

## Usage

'''
git clone https://github.com/ya-mat/eigen_benchmark.git
cd eigen_benchmark
make
./a.out && ./f.out
'''

## Measurements

- matrix multiplication
- matrix inversion
- LU decomposition
