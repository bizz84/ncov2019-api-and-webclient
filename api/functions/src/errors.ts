
export function accessTokenRequiresGetMethodErrorData(method: string) {
    return {
        error: {
            code: 1001,
            message: 'token should be called with the POST method',
            description: `Called token with ${method} method. Use POST instead`
        }
    }
}

export function accessTokenRequiresBasicAuthorizationErrorData() {
    return {
        error: {
            code: 1002,
            message: 'Missing or invalid authorization header',
            description: `token must be called with an {'Authorization': 'Basic <apiKey>'} header`
        }
    }
}

export function authorizationKeyDoesNotExistErrorData(authorizationKey: string) {
    return {
        error: {
            code: 1003,
            message: `authorizationKey ${authorizationKey} does not exist`,
            description: `authorizationKey ${authorizationKey} does not exist in the system`
        }
    }
}

export function missingUidEnvironmentAuthorizationKeyErrorData(authorizationKey: string) {
    return {
        error: {
            code: 1004,
            message: `Missing data for authorizationKey ${authorizationKey}`,
            description: `Could not find 'uid', 'environment' for authorizationKey ${authorizationKey}`
        }
    }
}

export function userNotFoundForAuthorizationKeyErrorData(authorizationKey: string) {
    return {
        error: {
            code: 1005,
            message: `User not found for authorizationKey ${authorizationKey}`,
            description: `User not found for authorizationKey ${authorizationKey}`
        }
    }
}

export function errorGeneratingAccessTokenErrorData(error: any) {
    return {
        error: {
            code: 1006,
            message: `Error generating access token: ${error}`,
            description: `Error generating access token: ${error}`
        }
    }
}

export function invalidTokenErrorData() {
    return {
        error: {
            code: 1007,
            message: 'Invalid Credentials',
            description: 'Access failure: make sure you have given the correct access token'
        }
    }
}

export function unavailableDataErrorData(endpoint: string) {
    return {
        error: {
            code: 1008,
            message: 'Data not available',
            description: `No data is available for the ${endpoint} endpoint`
        }
    }
}