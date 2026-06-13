from pathlib import Path
import csv

file_name = "ListingsData.csv"
# Replace path with where your csvs are stored
p = Path(r"C:\Users\shake\Desktop\Data Project\Python CSV Combiner\CSVs") / file_name

with open(p, 'r', encoding='utf-8', errors='replace') as f:
    raw = f.read()

# Normalize newlines
raw = raw.replace('\r\n', '\n').replace('\r', '\n')

# Fix backslash-escaped quotes \" -> "" (convert to proper CSV doublequote style)
raw = raw.replace('\\"', '""')

# Fix backslash-escaped single quotes \' -> '
raw = raw.replace("\\'", "'")

# Remove any remaining lone backslashes
raw = raw.replace('\\', ' ')

# Fix embedded newlines inside quoted fields character by character
def fix_quoted_newlines(text):
    result = []
    in_quotes = False
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == '"':
            in_quotes = not in_quotes
            result.append(ch)
        elif ch == '\n' and in_quotes:
            result.append(' ')
        else:
            result.append(ch)
        i += 1
    return ''.join(result)

raw = fix_quoted_newlines(raw)

# Parse
lines = [l for l in raw.split('\n') if l.strip()]
rows = []
bad_rows = []
reader = csv.reader(lines, quotechar='"', doublequote=True)
for i, row in enumerate(reader, 1):
    if len(row) == 73:
        rows.append(row)
    else:
        bad_rows.append((i, len(row)))

print(f"Good rows: {len(rows)}")
print(f"Bad rows: {len(bad_rows)}")
for i, count in bad_rows:
    print(f"  Row {i}: {count} fields")

# Write
with open("ListingsDataCleaned.csv", 'w', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f, delimiter=',', quoting=csv.QUOTE_ALL, doublequote=True)
    writer.writerows(rows)

print("Done")