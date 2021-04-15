## Test environments

* local R installation, R 4.0.3
* Ubuntu Linux 20.04.1 LTS, R-release, GCC (on rhub)
* Fedora Linux, R-devel, clang, gfortran (on rhub)
* Mac OS X 10.15.7 (on Github), R 4.0.4
* Microsoft Windows Server 2019 10.0.17763 (on Github), R 4.0.4
* Ubuntu 20.04.2 (on Github), R 4.0.4

## R CMD check results

0 errors | 0 warnings | 0 notes

* Reran `usethis::use_mit_license("James Hollway")`. MIT License file now contains only the standard two lines.
* Removed `\dontrun` from examples. `netlm()` now runs in <5 seconds.