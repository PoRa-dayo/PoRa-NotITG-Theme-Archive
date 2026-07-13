import re
import os

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------

# Input file to process
INPUT_FILE = "BGAnimation.ini"

# Output file
OUTPUT_FILE = "BGAnimation.ini"

# ------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------

def parse_command_effects(command_text):
    """
    Converts:
        x,129;y,232;addx,8
    into:
        [("x", "129"), ("y", "232"), ("addx", "8")]
    """
    effects = []

    for part in command_text.split(";"):
        part = part.strip()
        if not part:
            continue

        if "," in part:
            name, value = part.split(",", 1)
            effects.append((name.strip(), value.strip()))
        else:
            effects.append((part.strip(), ""))

    return effects


def build_command_string(effects):
    """
    Converts:
        [("x","1"), ("y","2")]
    back into:
        x,1;y,2
    """
    result = []

    for name, value in effects:
        if value == "":
            result.append(name)
        else:
            result.append(f"{name},{value}")

    return ";".join(result)


# ------------------------------------------------------------------
# Read file
# ------------------------------------------------------------------

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    lines = f.readlines()

# ------------------------------------------------------------------
# Process lines
# ------------------------------------------------------------------

i = 0

while i < len(lines):

    line = lines[i].rstrip("\n")

    # --------------------------------------------------------------
    # Process Command=
    # --------------------------------------------------------------
    if (
        line.startswith("Command=")
        or line.startswith("RepeatCommand=")
        or line.startswith("OnCommand=")
    ):

        if line.startswith("RepeatCommand="):
            command_prefix = "RepeatCommand="
        elif line.startswith("OnCommand="):
            command_prefix = "OnCommand="
        else:
            command_prefix = "Command="

        command_text = line[len(command_prefix):]

        # Do not modify the generated repeat command
        if command_text.strip() == "queuecommand,Repeat":
            i += 1
            continue

        # ----------------------------------------------------------
        # Format:
        # Command=%function(self) self:x(123) self:y(456)
        # ----------------------------------------------------------
        if command_text.startswith("%function(self)"):

            has_x = bool(re.search(r"self:x\([^)]*\)", command_text))
            has_y = bool(re.search(r"self:y\([^)]*\)", command_text))

            # if it already has SCREEN_CENTER then ignore it
            command_text = re.sub(
                r"self:x\(([^)]*)\)",
                lambda m: (
                    m.group(0)
                    if "SCREEN_CENTER_X" in m.group(1)
                    else f"self:x(SCREEN_CENTER_X+({m.group(1).strip()}-320))"
                ),
                command_text
            )

            command_text = re.sub(
                r"self:y\(([^)]*)\)",
                lambda m: (
                    m.group(0)
                    if "SCREEN_CENTER_Y" in m.group(1)
                    else f"self:y(SCREEN_CENTER_Y+({m.group(1).strip()}-240))"
                ),
                command_text
            )

            insert_text = ""

            if not has_x:
                insert_text += " self:x(SCREEN_CENTER_X)"

            if not has_y:
                insert_text += " self:y(SCREEN_CENTER_Y)"

            command_text = command_text.replace(
                "%function(self)",
                "%function(self)" + insert_text,
                1
            )

            lines[i] = command_prefix + command_text + "\n"

            i += 1
            continue

        # ----------------------------------------------------------
        # Format: Command=x,123;y,456
        # ----------------------------------------------------------


        effects = parse_command_effects(command_text)

        has_x = False
        has_y = False

        # Sum of linear/accelerate/decelerate/sleep durations
        timing_total = 0.0

        for index, (name, value) in enumerate(effects):

            # Exact x only
            if name == "x":
                has_x = True
                if "SCREEN_CENTER_X" not in value:
                    effects[index] = (
                        "x",
                        f"SCREEN_CENTER_X+({value}-320)"
                    )

            # Exact y only
            elif name == "y":
                has_y = True
                if "SCREEN_CENTER_Y" not in value:
                    effects[index] = (
                        "y",
                        f"SCREEN_CENTER_Y+({value}-240)"
                    )
                    
            # Change clearzbuffer from boolean to number
            elif name == "clearzbuffer":
                if value.lower() == "true":
                    effects[index] = ("clearzbuffer", "1")
                elif value.lower() == "false":
                    effects[index] = ("clearzbuffer", "0")

            # Change backfacecull names to numbers
            elif name == "backfacecull":
                if value.lower() == "front":
                    effects[index] = ("backfacecull", "0")
                elif value.lower() == "back":
                    effects[index] = ("backfacecull", "1")

            # Gather timing values
            elif name in ("linear", "accelerate", "decelerate", "sleep"):
                try:
                    timing_total += float(value)
                except ValueError:
                    pass

        # Add missing x/y immediately after Command=
        prepend_effects = []

        if not has_x:
            prepend_effects.append(("x", "SCREEN_CENTER_X"))

        if not has_y:
            prepend_effects.append(("y", "SCREEN_CENTER_Y"))

        effects = prepend_effects + effects

        # ----------------------------------------------------------
        # Look for matching CommandRepeatSeconds=
        # Can be directly above or directly below
        # ----------------------------------------------------------

        repeat_index = None
        repeat_value = None

        # Check previous line
        if i > 0:
            prev_line = lines[i - 1].strip()
            if prev_line.startswith("CommandRepeatSeconds="):
                repeat_index = i - 1
                repeat_value = prev_line.split("=", 1)[1].strip().rstrip(";")

        # Check next line
        if repeat_index is None and i + 1 < len(lines):
            next_line = lines[i + 1].strip()
            if next_line.startswith("CommandRepeatSeconds="):
                repeat_index = i + 1
                repeat_value = next_line.split("=", 1)[1].strip().rstrip(";")

        # ----------------------------------------------------------
        # Convert repeat logic if CommandRepeatSeconds exists
        # ----------------------------------------------------------

        if repeat_index is not None:

            sleep_expression = f"({repeat_value}-{timing_total})"

            effects.append(("sleep", sleep_expression))
            effects.append(("queuecommand", "Repeat"))

            lines[i] = (
                "RepeatCommand="
                + build_command_string(effects)
                + "\n"
            )

            lines[repeat_index] = "Command=queuecommand,Repeat\n"

        else:
            lines[i] = (
                command_prefix
                + build_command_string(effects)
                + "\n"
            )

    i += 1

# ------------------------------------------------------------------
# Convert processed BGAnimation.ini to default.xml
# ------------------------------------------------------------------

processed_text = "".join(lines)
processed_lines = processed_text.splitlines()

sections = []
current = []

for line in processed_lines:
    stripped = line.strip()

    if stripped.startswith("[") and stripped.endswith("]"):
        if current:
            sections.append(current)
        current = []
    else:
        if stripped:
            current.append(stripped)

if current:
    sections.append(current)

xml = ["<ActorFrame><children>", ""]

for section in sections:

    props = {}

    for line in section:
        if "=" not in line:
            continue

        key, value = line.split("=", 1)

        if key == "Import":
            key = "File"

        props[key] = value

    if not props:
        continue

    # ----------------------------------------------------------
    # LengthSeconds
    # ----------------------------------------------------------

    if "LengthSeconds" in props:
        try:
            length = float(props["LengthSeconds"])
        except ValueError:
            length = 999999

        if length <= 100:
            xml.extend([
                "    <Layer",
                '        Type="Quad"',
                f'        OnCommand="hidden,1;sleep,{props["LengthSeconds"]}"',
                "    />",
                ""
            ])

        continue

    # ----------------------------------------------------------
    # Model (.txt)
    # ----------------------------------------------------------

    file_value = props.get("File", "")
    fov_value = props.get("FOV")

    if file_value.lower().endswith(".txt"):

        if fov_value:
            xml.extend([
                '    <ActorFrame OnCommand="%function(self)',
            f'        self:fov(RealFOV({fov_value}))',
                '    end"><children>',
                ""
            ])

            layer_indent = "        "
            attr_indent = "            "

        else:
            layer_indent = "    "
            attr_indent = "        "

        xml.append(f"{layer_indent}<Layer")

        xml.append(f'{attr_indent}Type="Model"')
        xml.append(f'{attr_indent}Meshes="{file_value}"')
        xml.append(f'{attr_indent}Materials="{file_value}"')
        xml.append(f'{attr_indent}Bones="{file_value}"')

        for key, value in props.items():
            if key in ("File", "Import", "FOV", "Type"):
                continue

            xml.append(f'{attr_indent}{key}="{value}"')

        xml.append(f"{layer_indent}/>")

        if fov_value:
            xml.extend([
                "",
                "    </children></ActorFrame>"
            ])

        xml.append("")
        continue

    # ----------------------------------------------------------
    # Tiles detection for normal Layers
    # ----------------------------------------------------------

    has_tiles = any(
        key.startswith("TilesStart")
        or key.startswith("TilesSpacing")
        or key.startswith("TileVelocity")
        for key in props
    )

    # ----------------------------------------------------------
    # Normal Layer
    # ----------------------------------------------------------
    if has_tiles:
        xml.append("    <!-- Tiles cannot be converted via this script. Please manually convert using customtexturerect and texcoordvelocity, and making sure that the source image's dimensions are powers of 2. -->")

    xml.append("    <Layer")

    for key, value in props.items():
        if key in ("FOV", "Type"):
            continue

        xml.append(f'        {key}="{value}"')

    xml.append("    />")
    xml.append("")

xml.append("</children></ActorFrame>")

with open("default.xml", "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(xml))

print("Finished. Output written to: default.xml")