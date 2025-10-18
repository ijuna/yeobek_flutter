run-web:
	@echo "Running 'flutter pub get' in apps/app_web..."
	@cd apps/app_web && flutter pub get
	@echo "Running Flutter app: /Volumes/Juna/junafront/tattoo_frontend/apps/app_web/lib/main.dart"
	@flutter run -d chrome --target=/Volumes/Juna/junafront/tattoo_frontend/apps/app_web/lib/main.dart


git-run-web:
	@echo "Running 'flutter pub get' in apps/app_web..."
	@cd /workspaces/tattoo_frontend/apps/app_web && flutter pub get
	@echo "Running Flutter app: /Volumes/Juna/junafront/tattoo_frontend/apps/app_web/lib/main.dart"
	@flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080

melos-test:
	dart run melos bootstrap     # 의존성 재스캔
	dart run melos run l10n      # AppLang 생성
	dart run melos run analyze   # (선택) 정적 분석
	dart run melos run test      # (test 스크립트 있다면)

go1:
	make bootstrap
	cd packages/features
	make build-clean
	make build
	cd apps/app_web
	make dummy-run


bootstrap:
	dart run melos bootstrap

build-clean:
	dart run build_runner clean

build:
	dart run build_runner build -d

dummy-run:
	flutter run -d chrome --dart-define=API_BASE_URL=https://dummyjson.com


# Melos bootstrap 후, features와 app_web을 순차적으로 빌드하고 실행합니다.
go1:
	@echo "=> Bootstrapping Melos..."
	@dart run melos bootstrap
	@echo "\n=> Running build_runner in packages/features..."
	@cd packages/features && dart run build_runner clean && dart run build_runner build -d
	@echo "\n=> Running Flutter web app (app_web)..."
	@cd apps/app_web && flutter run -d chrome --dart-define=API_BASE_URL=https://dummyjson.com

.PHONY: go1



#
#
#
### Chrome 설치
#sudo apt-get update
#sudo apt-get install -y chromium || sudo apt-get install -y chromium-browser
#export CHROME_EXECUTABLE="$(which chromium || which chromium-browser)"
#echo 'export CHROME_EXECUTABLE="$(which chromium || which chromium-browser)"' >> ~/.zshrc
#echo 'export CHROME_EXECUTABLE="$(which chromium || which chromium-browser)"' >> ~/.bashrc
#flutter doctor
#cd /workspaces/tattoo_frontend/apps/app_web
#flutter run -d chrome
#
#
##flutter
#export PATH="$HOME/flutter/bin:$PATH"
##로그인시 잡혀라
#echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
#echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
#bash -l
## 또는
#source ~/.bashrc