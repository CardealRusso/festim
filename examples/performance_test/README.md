| Compiler Options               | Min | Max | Avg   |
|-------------------------------|-----|-----|-------|
| gcc                           | 33  | 34  | 33.5  |
| gcc      danger               | 34  | 45  | 40.5  |
| gcc      danger lto           | 40  | 58  | 51.5  |
| gcc      danger lto pgo -O3   | 45  | 66  | 58.3  |
|                               |     |     |       |
| clang                         | 30  | 31  | 30.5  |
| clang    danger               | 47  | 50  | 48.5  |
| clang    danger lto           | 26  | 47  | 41.5  |
| clang    danger pgo           | 47  | 50  | 48.7  |
| clang    danger lto pgo       | 35  | 50  | 43.7  |

clang 19.1, gcc 13.2