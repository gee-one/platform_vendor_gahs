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

include external/google-fonts/google-sans/fonts.mk

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/gahs/overlay

# Fonts configuration
PRODUCT_COPY_FILES += \
    vendor/gahs/config/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# Default permissions whitelist
PRODUCT_COPY_FILES += \
    vendor/gahs/config/default-permissions-gahs.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-gahs.xml

PRODUCT_PACKAGES += \
    ThemePicker \
    GahsThemesStub \
    bootanimation.zip \
    bootanimation-dark.zip
