#!/bin/bash
#
# Copyright (C) 2020 shagbag913
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
SCREEN_WIDTH="$1"
SCREEN_HEIGHT="$2"
PRODUCT_OUT="$3"
COLOR="$4"

BOOTANIMATION_OUT="$PRODUCT_OUT"/obj/BOOTANIMATION

LOGO_TO_SCREEN_RATIO=".42407407407"
LOGO_HEIGHT_TO_WIDTH_RATIO=".33624454148"

FRAME_WIDTH=$(printf '%.0f\n' $(echo "$SCREEN_WIDTH * $LOGO_TO_SCREEN_RATIO" | bc))
FRAME_HEIGHT=$(printf '%0.f\n' $(echo "$FRAME_WIDTH * $LOGO_HEIGHT_TO_WIDTH_RATIO" | bc))
SCREEN_WIDTH_HALF=$(printf '%.0f\n' $(echo "$SCREEN_WIDTH / 2" | bc))
SCREEN_HEIGHT_HALF=$(printf '%.0f\n' $(echo "$SCREEN_HEIGHT / 2" | bc))
FRAME_WIDTH_HALF=$(printf '%.0f\n' $(echo "$FRAME_WIDTH / 2" | bc))
FRAME_HEIGHT_HALF=$(printf '%0.f\n' $(echo "$FRAME_HEIGHT / 2" | bc))
Y_OFFSET=$((SCREEN_HEIGHT_HALF-FRAME_HEIGHT_HALF))
X_OFFSET=$((SCREEN_WIDTH_HALF-FRAME_WIDTH_HALF))
TRIM_DIMENSIONS="${FRAME_WIDTH}x${FRAME_HEIGHT}+${X_OFFSET}+${Y_OFFSET}"

if [ "$(uname -s)" = "Linux" ]; then
    MOGRIFY=prebuilts/tools-extra/linux-x86/bin/mogrify
else
    MOGRIFY=prebuilts/tools-extra/darwin-x86/bin/mogrify
fi

if [ "$COLOR" = "light" ]; then
    RGB="#FFFFFF"
else
    RGB="#000000"
    SUFFIX="-dark"
fi

if [ ! -d "$BOOTANIMATION_OUT" ]; then
    mkdir -p "$BOOTANIMATION_OUT"
fi

cp -r vendor/gahs/bootanimation/"$COLOR" "$BOOTANIMATION_OUT"

echo "$SCREEN_WIDTH $SCREEN_HEIGHT 60" > "$BOOTANIMATION_OUT"/"$COLOR"/desc.txt
echo "c 1 0 part0 $RGB" >> "$BOOTANIMATION_OUT"/"$COLOR"/desc.txt
echo "p 0 0 part1 $RGB" >> "$BOOTANIMATION_OUT"/"$COLOR"/desc.txt
echo "c 1 0 part2 $RGB" >> "$BOOTANIMATION_OUT"/"$COLOR"/desc.txt

for part in part0 part1 part2; do
    for png in "$BOOTANIMATION_OUT"/"$COLOR"/"$part"/*.png; do
        "$MOGRIFY" -geometry "$FRAME_WIDTH" "$png"
        echo "$TRIM_DIMENSIONS" >> "$BOOTANIMATION_OUT"/"$COLOR"/"$part"/trim.txt
    done
done

cd "$BOOTANIMATION_OUT"/"$COLOR"
zip -0qry -i \*.txt \*.png @ bootanimation"$SUFFIX".zip *.txt part*
