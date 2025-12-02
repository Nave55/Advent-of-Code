#pragma once

#include <math.h>
#include <algorithm>
#include <array>
#include <fstream>
#include <iostream>
#include <memory>
#include <numeric>
#include <ostream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

typedef std::vector<int> vi;
typedef std::vector<std::vector<int>> vvi;
typedef std::vector<float> vf;
typedef std::vector<std::vector<float>> vvf;
typedef std::vector<std::string> vs;
typedef std::vector<std::vector<std::string>> vvs;
typedef std::vector<char> vc;
typedef std::vector<std::vector<char>> vvc;

// Overload << for printing vectors
template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &arr) {
  os << "[";
  for (size_t i{0}; i < arr.size(); ++i) {
    os << arr[i];
    if (i < arr.size() - 1) {
      os << ",";
    }
  }
  os << "]\n";
  return os;
}

// Overload << for printing vectors
template <typename T, size_t N>
std::ostream &operator<<(std::ostream &os, const std::array<T, N> &arr) {
  os << "[";
  for (size_t i{0}; i < arr.size(); ++i) {
    os << arr[i];
    if (i < arr.size() - 1) {
      os << ",";
    }
  }
  os << "]\n";
  return os;
}

// Overload << for printing pairs
template <typename T>
std::ostream &operator<<(std::ostream &os, const std::pair<T, T> &pair) {
  os << "[" << pair.first << ", " << pair.second << "]\n";
  return os;
}

/**
 * @brief Calculates the average value of a vector
 * @param arr The vector to calculate the average of
 * @return The average value of the vector, or 0 if the vector is empty
 */

/**
 * @brief Prints the elements of a C-style array in a formatted manner
 *
 * @param arr The C-style array to print
 *
 * The function outputs the elements of the array to the standard output stream
 * in a human-readable format, enclosed in square brackets and separated by
 * commas.
 */

template <typename T, std::size_t N>
auto printCArr(const T (&arr)[N]) -> void {
  for (size_t i{0}; i < N; ++i) {
    if (i == 0) {
      std::cout << "[" << arr[i] << ", ";
    } else if (i > 0 && i < N - 1) {
      std::cout << arr[i] << ", ";
    } else {
      std::cout << arr[i] << "]\n";
    }
  }
}

template <typename T>
float avgVal(const std::vector<T> &arr) {
  if (arr.size() != 0)
    return (float)std::accumulate(arr.begin(), arr.end(), 0) / arr.size();
  return 0;
}

/**
 * @brief Returns the minimum value of a vector
 * @param arr The vector to find the minimum of
 * @return The minimum value of the vector, or 0 if the vector is empty
 */
template <typename T>
T minVal(const std::vector<T> &arr) {
  if (arr.size() != 0) return *std::ranges::min_element(arr);
  return 0;
}

/**
 * @brief Returns the maximum value of a vector
 * @param arr The vector to find the maximum of
 * @return The maximum value of the vector, or 0 if the vector is empty
 */
template <typename T>
T maxVal(const std::vector<T> &arr) {
  if (arr.size() != 0) return *std::ranges::max_element(arr);
  return 0;
}

/**
 * @brief Joins all elements of a container together into a string
 *        with a given delimiter
 * @param arr The container to join
 * @param delim The delimiter to insert between elements
 * @return A string with all elements of arr joined together with delim
 */
template <typename T>
std::string tJoin(const T &arr, const char delim) {
  std::string str{""};
  for (size_t i{0}; i < arr.size(); ++i) {
    if (i < arr.size() - 1) {
      str += arr.at(i);
      str += delim;
    } else
      str += arr.at(i);
  }
  return str;
}

/**
 * @brief Joins all elements of a container together into a string
 *        without a delimiter
 * @param arr The container to join
 * @return A string with all elements of arr joined together
 */
template <typename T>
std::string tJoin(const T &arr) {
  std::string str{""};
  for (size_t i{0}; i < arr.size(); ++i) {
    if (i < arr.size() - 1) {
      str += arr.at(i);
    } else
      str += arr.at(i);
  }
  return str;
}

/**
 * @brief Splits a string into a vector of elements of type T based on a given
 * delimiter.
 *
 * @details This function splits the input string s into a vector of elements of
 * type T. The elements are obtained by splitting the string at each occurrence
 * of the delimiter character. If the type T is int, the elements of the vector
 * are converted to integers using std::stoi. Otherwise, the elements are simply
 * copied as strings.
 *
 * @param s The input string to be split.
 * @param del The delimiter character to split the string on. Default is ','.
 * @return A vector of elements of type T obtained by splitting the string s
 * using the delimiter del.
 */

template <typename T>
std::vector<T> tSplit(const std::string &s, const char delim = ',') {
  std::vector<T> result;
  std::istringstream iss(s);
  std::string token;

  while (std::getline(iss, token, delim)) {
    if constexpr (std::is_same_v<T, int>) {
      result.push_back(std::stoi(token));
    } else {
      result.push_back(token);
    }
  }

  return result;
}

/**
 * @brief Element-wise addition of two pairs
 *
 * @param arr The first pair to add
 * @param arr2 The second pair to add
 * @return A new pair with elements that are the sum of the corresponding
 * elements of arr and arr2
 */

template <typename T>
std::pair<T, T> operator+(const std::pair<T, T> &arr,
                          const std::pair<T, T> &arr2) {
  return {arr.first + arr2.first, arr.second + arr2.second};
}

/**
 * @brief Element-wise subtraction of two pairs
 *
 * @param arr The first pair to subtract from
 * @param arr2 The second pair to subtract
 * @return A new pair with elements that are the difference of the corresponding
 * elements of arr and arr2
 */

template <typename T>
std::pair<T, T> operator-(const std::pair<T, T> &arr,
                          const std::pair<T, T> &arr2) {
  return {arr.first - arr2.first, arr.second - arr2.second};
}

/**
 * @brief Element-wise multiplication of a pair by a scalar
 *
 * @param arr The pair to multiply
 * @param scalar The scalar to multiply by
 * @return A new pair with elements that are the product of the corresponding
 * elements of arr and scalar
 */
template <typename T>
std::pair<T, T> operator*(const std::pair<T, T> &arr, T scalar) {
  return {arr.first * scalar, arr.second * scalar};
}

/**
 * @brief Element-wise addition of two arrays
 *
 * @param arr The first array to add
 * @param arr2 The second array to add
 * @return A new array with elements that are the sum of the corresponding
 * elements of arr and arr2
 */
template <typename T, std::size_t N>
std::array<T, N> operator+(const std::array<T, N> &arr,
                           const std::array<T, N> &arr2) {
  std::array<T, N> result{};
  for (size_t i{0}; i < arr.size(); i++) {
    result[i] = arr[i] + arr2[i];
  }
  return result;
}

/**
 * @brief Element-wise addition of an array and a vector
 *
 * @param arr The array to add
 * @param arr2 The vector to add
 * @return A new array with elements that are the sum of the corresponding
 * elements of arr and arr2
 */

template <typename T, std::size_t N>
std::array<T, N> operator+(const std::array<T, N> &arr,
                           const std::vector<T> &arr2) {
  std::vector<T> result{};
  for (size_t i{0}; i < arr.size(); i++) {
    result.emplace_back(arr[i] + arr2[i]);
  }
  return result;
}

/**
 * @brief Element-wise addition of two vectors
 *
 * @param arr The first vector to add
 * @param arr2 The second vector to add
 * @return A new vector with elements that are the sum of the corresponding
 * elements of arr and arr2
 */
template <typename T>
std::vector<T> operator+(const std::vector<T> &arr,
                         const std::vector<T> &arr2) {
  std::vector<T> result{};
  for (size_t i{0}; i < arr.size(); i++) {
    result.emplace_back(arr[i] + arr2[i]);
  }
  return result;
}

/**
 * @brief Retrieves the value from a 2D vector at a specified location
 * @param arr The 2D vector from which to retrieve the value
 * @param arr2 An array containing the row and column indices for the desired
 * value
 * @return The value at the specified location in the 2D vector
 */

template <typename T>
T arrValue(const std::vector<std::vector<T>> &arr,
           const std::array<int, 2> &arr2) {
  return arr[arr2[0]][arr2[1]];
}

template <typename T>
T arrValue(const std::vector<std::vector<T>> &arr,
           const std::pair<int, int> &arr2) {
  /**
   * @brief Retrieves the value from a 2D vector at a specified row and column
   * index
   * @param arr The 2D vector from which to retrieve the value
   * @param arr2 A pair representing the row and column indices
   * @return The value at the specified row and column index in the 2D vector
   */

  return arr[arr2.first][arr2.second];
}

/**
 * @brief Retrieves the value from a 2D array at a specified row and column
 * index
 *
 * @param arr The 2D array from which to retrieve the value
 * @param arr2 A pair representing the row and column indices
 * @return The value at the specified row and column index in the 2D array
 */
template <typename T, size_t N, size_t M>
T arrValue(const T (&arr)[N][M], const std::pair<int, int> &arr2) {
  return arr[arr2.first][arr2.second];
}

/**
 * @brief Retrieves the value from a 2D array at a specified row and column
 * index
 *
 * @param arr The 2D array from which to retrieve the value
 * @param arr2 A pair representing the row and column indices
 * @return The value at the specified row and column index in the 2D array
 */
template <typename T, size_t N, size_t M>
T arrValue(const std::array<std::array<T, N>, M> &arr,
           const std::pair<int, int> &arr2) {
  return arr[arr2.first][arr2.second];
}

template <typename T>
bool inBounds(const std::vector<std::vector<T>> &arr,
              const std::pair<int, int> &pos) {
  /**
   * @brief Checks if a given pair of indices is within the bounds of a 2D
   * vector
   * @param arr The 2D vector to check against
   * @param pos The pair of indices to check
   * @return true if the indices are within the bounds of the vector, false
   * otherwise
   */
  return (pos.first >= 0 && pos.second >= 0 &&
          static_cast<size_t>(pos.first) < arr.size() &&
          static_cast<size_t>(pos.second) < arr[0].size());
}

/**
 * @brief Checks if a given pair of indices is within the bounds of a 2D array
 * @param pos The pair of indices to check
 * @param height The height of the 2D array
 * @param width The width of the 2D array
 * @return true if the indices are within the bounds of the array, false
 * otherwise
 */

bool inBounds(const std::pair<int, int> &pos, size_t height, size_t width) {
  return (pos.first >= 0 && pos.second >= 0 &&
          static_cast<size_t>(pos.first) < height &&
          static_cast<size_t>(pos.second) < width);
}

template <typename V, std::size_t N>
struct Nbrs {
  std::array<std::pair<int, int>, N> indices;
  std::array<V, N> vals;
  std::size_t size = 0;  // To keep track of actual filled elements
};

/**
 * @brief Finds the neighbors of a given location in a 2D vector
 *
 * @param arr The 2D vector to search for neighbors
 * @param loc The location to search for neighbors
 * @param type The type of neighbors to search for. 'n' for non-diagonal
 * neighbors, 'd' for diagonal neighbors, 'a' for all neighbors
 * @return A struct containing the indices and values of the neighbors
 */
template <typename V, std::size_t N>
Nbrs<V, N> nbrs(const std::vector<std::vector<V>> &arr,
                const std::pair<int, int> &loc, char type = 'n') {
  auto height = arr.size();
  auto width = arr[0].size();

  std::array<std::pair<int, int>, 8> all = {
      {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}};
  std::array<std::pair<int, int>, 4> diag = {
      {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}};
  std::array<std::pair<int, int>, 4> lrup = {
      {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}};

  Nbrs<V, N> result;

  if (type == 'n') {
    for (const auto &i : lrup) {
      std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};
      if (inBounds(tmp, height, width)) {
        result.indices[result.size] = tmp;
        result.vals[result.size] = arrValue(arr, tmp);
        result.size++;
      }
    }
  }
  if (type == 'd') {
    for (const auto &i : diag) {
      std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};
      if (inBounds(tmp, height, width)) {
        result.indices[result.size] = tmp;
        result.vals[result.size] = arrValue(arr, tmp);
        result.size++;
      }
    }
  }
  if (type == 'a') {
    for (const auto &i : all) {
      std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};
      ;
      if (inBounds(tmp, height, width)) {
        result.indices[result.size] = tmp;
        result.vals[result.size] = arrValue(arr, tmp);
        result.size++;
      }
    }
  }

  return result;
}

/**
 * @brief Converts a pair of type T to a string in the format "first,second"
 * @param pair The pair to convert
 * @return A string representing the pair
 */
template <typename T>
auto pairToStr(const std::pair<T, T> &pair) -> std::string {
  return std::to_string(pair.first) + "," + std::to_string(pair.second);
}

template <typename T>
auto strToPair(std::string str) -> std::pair<T, T> {
  /**
   * @brief Converts a string representation of a pair to a std::pair of type T
   *
   * @tparam T The type of elements in the returned pair
   * @param str The string containing the pair, formatted as "first,second"
   * @return A std::pair with the elements parsed from the string
   */

  std::stringstream ss(str);
  T first, second;
  char delimiter;
  ss >> first >> delimiter >> second;
  return std::make_pair(first, second);
}

struct pair_hash {
  /**
   * @brief Hash function for a pair of elements
   *
   * @tparam T1 The type of the first element in the pair
   * @tparam T2 The type of the second element in the pair
   * @param pair The pair to hash
   * @return A std::size_t representing the hash of the pair
   *
   * This function computes a hash value for a given std::pair by combining the
   * hash values of its elements. It uses XOR and a prime multiplier to
   * reduce the likelihood of hash collisions.
   */

  template <class T1, class T2>
  std::size_t operator()(const std::pair<T1, T2> &pair) const {
    std::size_t h1 = std::hash<T1>()(pair.first);
    std::size_t h2 = std::hash<T2>()(pair.second);
    return h1 ^ (h2 * 31);  // Use a prime multiplier
  }
};
