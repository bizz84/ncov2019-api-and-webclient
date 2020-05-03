import * as crypto from 'crypto'

export function generateUuid() {
    // https://stackoverflow.com/a/40191779/436422
    return crypto.randomBytes(32).toString('hex')
}