class CloudStorageException implements Exception
{
  const CloudStorageException();
}
class CouldNotGetAllEventsException extends CloudStorageException
{

}

class CouldNotCreateEventException extends CloudStorageException
{

}

class CouldNotUpdateEventException extends CloudStorageException
{

}

class CouldNotDeleteEventException extends CloudStorageException
{

}

class UnknownErrorException extends CloudStorageException
{

}
class ObjectNotFoundException extends CloudStorageException
{

}


class BucketNotFoundException extends CloudStorageException {
}

class ProjectNotFoundException extends CloudStorageException {
}

class QuotaExceededException extends CloudStorageException {
}

class UnauthenticatedException extends CloudStorageException {

}

class UnauthorizedException extends CloudStorageException {

}

class RetryLimitExceededException extends CloudStorageException {

}

class InvalidChecksumException extends CloudStorageException {

}

class CanceledException extends CloudStorageException {

}

class InvalidEventNameException extends CloudStorageException {

}

class InvalidUrlException extends CloudStorageException {

}

class InvalidArgumentException extends CloudStorageException {

}

class NoDefaultBucketException extends CloudStorageException {

}

class CannotSliceBlobException extends CloudStorageException {

}

class ServerFileWrongSizeException extends CloudStorageException {

}

class CouldNotDeleteTicketsException extends CloudStorageException
{

}

class CouldNotUpdateParticipantsException extends CloudStorageException
{

}

