# NOTE: This script expects environment variables to be passed for the Salesforce
# credentials to the orgs: feature, master, packaging, beta, prod such as...
# SF_USERNAME_FEATURE
# SF_PASSWORD_MASTER
# SF_SERVERURL_PACKAGING

# Setup variables for branch naming conventions using env overrides if set
if [ "$MASTER_BRANCH" == "" ]; then

fi
if [ "$PREFIX_FEATURE" == "" ]; then
    PREFIX_FEATURE='feature/'
fi
if [ "$PREFIX_BETA" == "" ]; then
    PREFIX_BETA='beta/'
fi
if [ "$PREFIX_PROD" == "" ]; then
    PREFIX_PROD='prod/'
fi

# Determine build type and setup Salesforce credentials
if [[ $CI_BRANCH == $MASTER_BRANCH ]]; then
    BUILD_TYPE='master'
elif [[ $CI_BRANCH == $PREFIX_FEATURE* ]]; then
    BUILD_TYPE='feature'
elif [[ $CI_BRANCH == $PREFIX_BETA* ]]; then
    BUILD_TYPE='beta'
elif [[ $CI_BRANCH == $PREFIX_PROD* ]]; then
    BUILD_TYPE='prod'    
fi

if [ "$BUILD_TYPE" == "" ]; then
    echo "BUILD FAILED: Could not determine BUILD_TYPE for $CI_BRANCH"
    exit 1
fi

# Run the build for the build type

# Master branch commit, build and test a beta managed package
if [ $BUILD_TYPE == "master" ]; then

    # Get org credentials from env
    export SF_USERNAME=$SF_USERNAME_PACKAGING
    export SF_PASSWORD=$SF_PASSWORD_PACKAGING
    export SF_SERVERURL=$SF_SERVERURL_PACKAGING
    
    # Deploy to packaging org
    ant deployCIPackageOrg
    
    # Upload beta package
    
    # Test beta
        # Retry if package is unavailable
        
    # Create GitHub Release
    
    # Merge master commit to all open feature branches

# Feature branch commit, build and test in local unmanaged package
elif [ $BUILD_TYPE == "feature" ]; then
    
    # Get org credentials from env
    export SF_USERNAME=$SF_USERNAME_FEATURE
    export SF_PASSWORD=$SF_PASSWORD_FEATURE
    export SF_SERVERURL=$SF_SERVERURL_FEATURE
    
    # Deploy to feature org
    ant deployCI

# Beta tag build, do nothing
elif [ $BUILD_TYPE == "beta" ]; then


# Prod tag build, deploy and test in packaging org
elif [ $BUILD_TYPE == "prod" ]; then
    
    # Get org credentials from env
    export SF_USERNAME=$SF_USERNAME_PACKAGING
    export SF_PASSWORD=$SF_PASSWORD_PACKAGING
    export SF_SERVERURL=$SF_SERVERURL_PACKAGING
    
    # Deploy to packaging org
    ant deployCIPackageOrg
    
fi
