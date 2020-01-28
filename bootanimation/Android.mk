#
# Copyright (C) 2016 The CyanogenMod Project
#               2017 The LineageOS Project
#               2020 shagbag913
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifeq ($(TARGET_SCREEN_WIDTH),)
    $(error TARGET_SCREEN_WIDTH is not set)
endif
ifeq ($(TARGET_SCREEN_HEIGHT),)
    $(error TARGET_SCREEN_HEIGHT is not set)
endif

define build-bootanimation
    $(shell) vendor/gahs/bootanimation/gen_bootanimation.sh \
    $(TARGET_SCREEN_WIDTH) \
    $(TARGET_SCREEN_HEIGHT) \
    $(PRODUCT_OUT) \
    $(1)
endef

TARGET_GENERATED_BOOTANIMATION := $(TARGET_OUT_INTERMEDIATES)/BOOTANIMATION/light/bootanimation.zip
$(TARGET_GENERATED_BOOTANIMATION):
	@echo "Building light bootanimation"
	$(call build-bootanimation,light)

TARGET_GENERATED_BOOTANIMATION_DARK := $(TARGET_OUT_INTERMEDIATES)/BOOTANIMATION/dark/bootanimation-dark.zip
$(TARGET_GENERATED_BOOTANIMATION_DARK):
	@echo "Building dark bootanimation"
	$(call build-bootanimation,dark)

ifeq ($(TARGET_BOOTANIMATION),)
    TARGET_BOOTANIMATION := $(TARGET_GENERATED_BOOTANIMATION)
endif
ifeq ($(TARGET_BOOTANIMATION_DARK),)
    TARGET_BOOTANIMATION_DARK := $(TARGET_GENERATED_BOOTANIMATION_DARK)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation.zip
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(TARGET_BOOTANIMATION)
	@mkdir -p $(dir $@)
	@cp $(TARGET_BOOTANIMATION) $@

include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation-dark.zip
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(TARGET_BOOTANIMATION_DARK)
	@mkdir -p $(dir $@)
	@cp $(TARGET_BOOTANIMATION_DARK) $@
