DIRECTORY_CLONED_REPOSITORY="shop-angular-cloudfront"

cd "$DIRECTORY_CLONED_REPOSITORY"

npm i

npm run lint

npm test

npm audit

if [ $? -eq 0 ]; then
	echo "Quality check passed. No issues found."
else
	echo "Quality check failed. Please review."
fi
