// AUTOGENERATED

import 'errors.dart';

final errorMapping = {
  0x01000000: InternalServerError.new,
  0x02000000: UnsupportedFeatureError.new,
  0x03000000: ProtocolError.new,
  0x03010000: BinaryProtocolError.new,
  0x03010001: UnsupportedProtocolVersionError.new,
  0x03010002: TypeSpecNotFoundError.new,
  0x03010003: UnexpectedMessageError.new,
  0x03020000: InputDataError.new,
  0x03020100: ParameterTypeMismatchError.new,
  0x03020200: StateMismatchError.new,
  0x03030000: ResultCardinalityMismatchError.new,
  0x03040000: CapabilityError.new,
  0x03040100: UnsupportedCapabilityError.new,
  0x03040200: DisabledCapabilityError.new,
  0x04000000: QueryError.new,
  0x04010000: InvalidSyntaxError.new,
  0x04010100: EdgeQLSyntaxError.new,
  0x04010200: SchemaSyntaxError.new,
  0x04010300: GraphQLSyntaxError.new,
  0x04020000: InvalidTypeError.new,
  0x04020100: InvalidTargetError.new,
  0x04020101: InvalidLinkTargetError.new,
  0x04020102: InvalidPropertyTargetError.new,
  0x04030000: InvalidReferenceError.new,
  0x04030001: UnknownModuleError.new,
  0x04030002: UnknownLinkError.new,
  0x04030003: UnknownPropertyError.new,
  0x04030004: UnknownUserError.new,
  0x04030005: UnknownDatabaseError.new,
  0x04030006: UnknownParameterError.new,
  0x04040000: SchemaError.new,
  0x04050000: SchemaDefinitionError.new,
  0x04050100: InvalidDefinitionError.new,
  0x04050101: InvalidModuleDefinitionError.new,
  0x04050102: InvalidLinkDefinitionError.new,
  0x04050103: InvalidPropertyDefinitionError.new,
  0x04050104: InvalidUserDefinitionError.new,
  0x04050105: InvalidDatabaseDefinitionError.new,
  0x04050106: InvalidOperatorDefinitionError.new,
  0x04050107: InvalidAliasDefinitionError.new,
  0x04050108: InvalidFunctionDefinitionError.new,
  0x04050109: InvalidConstraintDefinitionError.new,
  0x0405010a: InvalidCastDefinitionError.new,
  0x04050200: DuplicateDefinitionError.new,
  0x04050201: DuplicateModuleDefinitionError.new,
  0x04050202: DuplicateLinkDefinitionError.new,
  0x04050203: DuplicatePropertyDefinitionError.new,
  0x04050204: DuplicateUserDefinitionError.new,
  0x04050205: DuplicateDatabaseDefinitionError.new,
  0x04050206: DuplicateOperatorDefinitionError.new,
  0x04050207: DuplicateViewDefinitionError.new,
  0x04050208: DuplicateFunctionDefinitionError.new,
  0x04050209: DuplicateConstraintDefinitionError.new,
  0x0405020a: DuplicateCastDefinitionError.new,
  0x04060000: SessionTimeoutError.new,
  0x04060100: IdleSessionTimeoutError.new,
  0x04060200: QueryTimeoutError.new,
  0x04060a00: TransactionTimeoutError.new,
  0x04060a01: IdleTransactionTimeoutError.new,
  0x05000000: ExecutionError.new,
  0x05010000: InvalidValueError.new,
  0x05010001: DivisionByZeroError.new,
  0x05010002: NumericOutOfRangeError.new,
  0x05010003: AccessPolicyError.new,
  0x05020000: IntegrityError.new,
  0x05020001: ConstraintViolationError.new,
  0x05020002: CardinalityViolationError.new,
  0x05020003: MissingRequiredError.new,
  0x05030000: TransactionError.new,
  0x05030100: TransactionConflictError.new,
  0x05030101: TransactionSerializationError.new,
  0x05030102: TransactionDeadlockError.new,
  0x06000000: ConfigurationError.new,
  0x07000000: AccessError.new,
  0x07010000: AuthenticationError.new,
  0x08000000: AvailabilityError.new,
  0x08000001: BackendUnavailableError.new,
  0x09000000: BackendError.new,
  0x09000100: UnsupportedBackendFeatureError.new,
  0xf0000000: LogMessage.new,
  0xf0010000: WarningMessage.new,
  0xff000000: ClientError.new,
  0xff010000: ClientConnectionError.new,
  0xff010100: ClientConnectionFailedError.new,
  0xff010101: ClientConnectionFailedTemporarilyError.new,
  0xff010200: ClientConnectionTimeoutError.new,
  0xff010300: ClientConnectionClosedError.new,
  0xff020000: InterfaceError.new,
  0xff020100: QueryArgumentError.new,
  0xff020101: MissingArgumentError.new,
  0xff020102: UnknownArgumentError.new,
  0xff020103: InvalidArgumentError.new,
  0xff030000: NoDataError.new,
  0xff040000: InternalClientError.new,
};
