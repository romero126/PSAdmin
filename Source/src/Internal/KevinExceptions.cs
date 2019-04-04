using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;

namespace PSAdmin.Internal
{
    public enum KevinBlumenfeldExceptionType {
        DatabaseNotOpen,
        ParameterSetNotFound,
        RowCreate,
        RowUpdate,
        RowDelete,
        ItemExists,
        ItemNotFound,
        ItemNotFoundLookup,
        QuotaExceeded,
        CertificatePrivateKey,
        ParameterNotSet,
        ParameterDefined   
    }

    public class KevinBlumenfeldException : Exception
    {
        public KevinBlumenfeldExceptionType ExceptionType;
        public string ErrorID = "KevinBlumenfeldException";

        public KevinBlumenfeldException(KevinBlumenfeldExceptionType exceptionType) : this(KevinBlumenfeldExceptionHelper.errorStrings[exceptionType], exceptionType, null)
        {
            
        }
        public KevinBlumenfeldException(KevinBlumenfeldExceptionType exceptionType, params string[] args) : this(exceptionType, null, args)
        {

        }
        public KevinBlumenfeldException(KevinBlumenfeldExceptionType exceptionType, Exception innerException, params string[] args) : this( String.Format( KevinBlumenfeldExceptionHelper.errorStrings[exceptionType], args), exceptionType, innerException)
        {

        }
        public KevinBlumenfeldException(string Message, KevinBlumenfeldExceptionType exceptionType, Exception innerException) : base(Message, innerException)
        {
            exceptionType = ExceptionType;
        }
        public ErrorRecord GetErrorRecord()
        {
            return new ErrorRecord(
                (Exception)this, ErrorID, KevinBlumenfeldExceptionHelper.errorCategory[ExceptionType], null
            );  
        }
    }
    public static class KevinBlumenfeldExceptionHelper {
        internal static Dictionary<KevinBlumenfeldExceptionType, String> errorStrings = new Dictionary<KevinBlumenfeldExceptionType, string> {
            { KevinBlumenfeldExceptionType.DatabaseNotOpen,          "Database not selected" },
            { KevinBlumenfeldExceptionType.ParameterSetNotFound,     "A Valid ParameterSetName could not be found" },
            { KevinBlumenfeldExceptionType.RowCreate,                "Unable to create item" },
            { KevinBlumenfeldExceptionType.RowUpdate,                "Unable to update item" },
            { KevinBlumenfeldExceptionType.RowDelete,                "Unable to delete item" },
            { KevinBlumenfeldExceptionType.ItemExists,               "The item already exists '{0}' with property name '{1}'" },
            { KevinBlumenfeldExceptionType.QuotaExceeded,            "Too many items found matching '{0}' in '{1}'" },
            { KevinBlumenfeldExceptionType.ItemNotFoundLookup,       "No item found matching '{0}' in '{1}'"},
            { KevinBlumenfeldExceptionType.ParameterNotSet,          "Parameter '{0}' expected but not defined"},
            { KevinBlumenfeldExceptionType.ParameterDefined,         "Parameter '{0}' was expected to not be defined"},
            { KevinBlumenfeldExceptionType.CertificatePrivateKey,    "The Certificate with the Thumbprint of '{0}' does not contain a PrivateKey" }
        };
        internal static Dictionary<KevinBlumenfeldExceptionType, ErrorCategory> errorCategory = new Dictionary<KevinBlumenfeldExceptionType, ErrorCategory> {
            { KevinBlumenfeldExceptionType.DatabaseNotOpen,          ErrorCategory.ResourceUnavailable },
            { KevinBlumenfeldExceptionType.ParameterSetNotFound,     ErrorCategory.InvalidOperation },
            { KevinBlumenfeldExceptionType.RowCreate,                ErrorCategory.WriteError },
            { KevinBlumenfeldExceptionType.RowUpdate,                ErrorCategory.WriteError },
            { KevinBlumenfeldExceptionType.RowDelete,                ErrorCategory.WriteError },
            { KevinBlumenfeldExceptionType.ItemExists,               ErrorCategory.ResourceExists },
            { KevinBlumenfeldExceptionType.QuotaExceeded,            ErrorCategory.QuotaExceeded },
            { KevinBlumenfeldExceptionType.ItemNotFoundLookup,       ErrorCategory.ObjectNotFound },
            { KevinBlumenfeldExceptionType.ParameterNotSet,          ErrorCategory.InvalidResult },
            { KevinBlumenfeldExceptionType.ParameterDefined,         ErrorCategory.InvalidResult },
            { KevinBlumenfeldExceptionType.CertificatePrivateKey,    ErrorCategory.NotEnabled }
        };
    }
}