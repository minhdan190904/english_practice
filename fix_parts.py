import os

models_dir = r'lib\data\models'
for fname in os.listdir(models_dir):
    if not fname.endswith('.dart') or fname.endswith('.g.dart') or fname.endswith('.freezed.dart'):
        continue
    fpath = os.path.join(models_dir, fname)
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()
    # Replace same-level part directives back to generated/ subfolder
    # Only for files that have freezed/g parts
    changed = False
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if line.startswith("part '") and not line.startswith("part 'generated/"):
            part_file = line.strip().removeprefix("part '").removesuffix("';").removesuffix("';\r")
            if part_file.endswith('.freezed.dart') or part_file.endswith('.g.dart'):
                new_line = f"part 'generated/{part_file}';"
                new_lines.append(new_line)
                changed = True
                continue
        new_lines.append(line)
    if changed:
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(new_lines))
        print(f'Reverted: {fname}')
