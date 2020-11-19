#include <iostream>
#include <Eigen/Dense>
#include <Eigen/LU>
#include <chrono>

int main()
{
  int n = 3000;
  Eigen::MatrixXd A = Eigen::MatrixXd::Random(n, n);
  Eigen::MatrixXd B = Eigen::MatrixXd::Random(n, n);
  std::chrono::system_clock::time_point start, end;
  double time;

  // multiplication
  start = std::chrono::system_clock::now();
  Eigen::MatrixXd C = A*B;
  end = std::chrono::system_clock::now();
  time = static_cast<double>(std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0);
  std::cout << "multiplication time " << time << std::endl;
  
  // inverse
  start = std::chrono::system_clock::now();
  Eigen::MatrixXd D = A.inverse();
  end = std::chrono::system_clock::now();
  time = static_cast<double>(std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0);
  std::cout << "inverse time " << time << std::endl;

  // LU inverse
  start = std::chrono::system_clock::now();
  Eigen::PartialPivLU<Eigen::MatrixXd> lu(A);
  Eigen::MatrixXd E = lu.inverse();
  end = std::chrono::system_clock::now();
  time = static_cast<double>(std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0);
  std::cout << "LU inverse time " << time << std::endl;

  // LU decomposition
  start = std::chrono::system_clock::now();
  Eigen::PartialPivLU<Eigen::MatrixXd> lu2;
  lu2.compute(A);
  end = std::chrono::system_clock::now();
  time = static_cast<double>(std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0);
  std::cout << "LU decomposition time " << time << std::endl;
}
