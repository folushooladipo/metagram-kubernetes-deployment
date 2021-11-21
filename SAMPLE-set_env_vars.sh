# This is the URL that feed-service will use to verify tokens. When running locally,
# it's value should be http://localhost:8081/api/v0/users/auth/verify-token
export AUTH_ENDPOINT=

# The URL for the AWS bucket that Metagram will be uploading images to. Create a bucket and supply its endpoint below.
export AWS_MEDIA_BUCKET_NAME=

# The name and region of the local AWS profile that you want to use. After setting up AWS CLI, you should have these values stored in ~/.aws/config.
export AWS_PROFILE=
export AWS_REGION=

# The connection credentials for the Postgres database that you want to use. Create one using AWS RDS and supply its details here.
export DB_HOST=
export DB_NAME=
export DB_USERNAME=
export DB_PASSWORD=

# This value is used by user-service and feed-service to allow cross-origin equests from the specified domain, as that domain is supposed to be an instance of the frontend-app.
export FRONTEND_APP_URL=

# A secret to use for generating JWT tokens. Make sure to use a strange value that is 30+ characters long and contains many numbers, uppercase letters, symbols/punctuation marks etc.
export JWT_SECRET=
