IOS_DEVICE ?= 42A52C2E-3A5E-454A-AA16-8015DCD39CF2
ANDROID_DEVICE ?= emulator-5554

run-ios:
	@echo "Running 'flutter pub get' in app..."
	@cd app && flutter pub get
	@echo "Launching Flutter app on iOS simulator..."
	@cd app && flutter run -d $(IOS_DEVICE)

run-android:
	@echo "Running 'flutter pub get' in app..."
	@cd app && flutter pub get
	@echo "Launching Flutter app on Android emulator..."
	@cd app && flutter run -d $(ANDROID_DEVICE)

melos-test:
	dart run melos bootstrap     # 의존성 재스캔
	dart run melos run l10n      # AppLang 생성
	dart run melos run analyze   # (선택) 정적 분석
	dart run melos run test      # (test 스크립트 있다면)

bootstrap:
	dart run melos bootstrap

build-clean:
	dart run build_runner clean

build:
	dart run build_runner build -d

test:
	cd app && flutter test

.PHONY: run-ios run-android melos-test bootstrap build-clean build test

push:
	git add .
	git commit -m "Update"
	git push		

