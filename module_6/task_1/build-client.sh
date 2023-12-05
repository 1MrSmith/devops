DIRECTORY_CLONED_REPOSITORY="shop-angular-cloudfront"

ENV=development

while [ $# -gt 0 ]; do
	case $1 in
		-c | --configuration)
		ENV="$2"
		shift
		shift
		;;
	esac
done


if [ ! -d "shop-angular-cloudfront" ]; then
	git clone https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront
fi

cd "$DIRECTORY_CLONED_REPOSITORY"

if [ -e "dist/client.zip" ]; then
	rm dist/client-app.zip
fi

npm i

npm run build -- --configuration=$ENV
pwd
cd dist
pwd
zip -r client-app.zip app

echo "Build successfully completed"
