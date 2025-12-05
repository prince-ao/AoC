data = "day4.txt"

def main():
    part1 = 0
    part2 = 0

    with open(data) as file:
        grid = [list(line.strip()) for line in file]

    while True:
        count, to_remove, stop = remove_count(grid)

        if stop:
            break

        if part1 == 0:
            part1 += count

        part2 += count

        for i, j in to_remove:
            grid[i][j] = "."


    return part1, part2

def remove_count(grid: list[list[str]]):
    count = 0;
    to_remove: list[tuple[int, int]] = []

    for i, row in enumerate(grid):
        for j, val in enumerate(row):
            if val == ".": continue

            cases = zip([0, -1, -1, 1, 1, 0, 1, -1], [-1, 0, -1, 0, -1, 1, 1, 1])
            case_count = 0

            for k, l in cases:
                if i + k >= 0 and i + k < len(grid) and j + l >= 0 and j + l < len(row):
                    if grid[i + k][j + l] == "@":
                        case_count += 1

            if case_count < 4:
                count += 1
                to_remove.append((i, j))


    return count, to_remove, count == 0



if __name__ == "__main__":
    part1, part2 = main()

    print(f"part 1 = {part1}")
    print(f"part 2 = {part2}")
