using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;

namespace PSAdmin.Internal
{
    public enum PSAdminExceptionType {
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

    public class PSAdminException : Exception
    {
        public PSAdminExceptionType ExceptionType;
        public string ErrorID = "PSAdminException";

        public PSAdminException(PSAdminExceptionType exceptionType) : this(PSAdminExceptionHelper.errorStrings[exceptionType], exceptionType, null)
        {
            
        }
        public PSAdminException(PSAdminExceptionType exceptionType, params string[] args) : this(exceptionType, null, args)
        {

        }
        public PSAdminException(PSAdminExceptionType exceptionType, Exception innerException, params string[] args) : this( String.Format( PSAdminExceptionHelper.errorStrings[exceptionType], args), exceptionType, innerException)
        {

        }
        public PSAdminException(string Message, PSAdminExceptionType exceptionType, Exception innerException) : base(Message, innerException)
        {
            exceptionType = ExceptionType;
        }
        public ErrorRecord GetErrorRecord()
        {
            return new ErrorRecord(
                (Exception)this, ErrorID, PSAdminExceptionHelper.errorCategory[ExceptionType], null
            );  
        }
    }
    public static class PSAdminExceptionHelper {
        internal static Dictionary<PSAdminExceptionType, String> errorStrings = new Dictionary<PSAdminExceptionType, string> {
            { PSAdminExceptionType.DatabaseNotOpen,          "Database not selected" },
            { PSAdminExceptionType.ParameterSetNotFound,     "A Valid ParameterSetName could not be found" },
            { PSAdminExceptionType.RowCreate,                "Unable to create item" },
            { PSAdminExceptionType.RowUpdate,                "Unable to update item" },
            { PSAdminExceptionType.RowDelete,                "Unable to delete item" },
            { PSAdminExceptionType.ItemExists,               "The item already exists '{0}' with property name '{1}'" },
            { PSAdminExceptionType.QuotaExceeded,            "Too many items found matching '{0}' in '{1}'" },
            { PSAdminExceptionType.ItemNotFoundLookup,       "No item found matching '{0}' in '{1}'"},
            { PSAdminExceptionType.ParameterNotSet,          "Parameter '{0}' expected but not defined"},
            { PSAdminExceptionType.ParameterDefined,         "Parameter '{0}' was expected to not be defined"},
            { PSAdminExceptionType.CertificatePrivateKey,    "The Certificate with the Thumbprint of '{0}' does not contain a PrivateKey" }
        };
        internal static Dictionary<PSAdminExceptionType, ErrorCategory> errorCategory = new Dictionary<PSAdminExceptionType, ErrorCategory> {
            { PSAdminExceptionType.DatabaseNotOpen,          ErrorCategory.ResourceUnavailable },
            { PSAdminExceptionType.ParameterSetNotFound,     ErrorCategory.InvalidOperation },
            { PSAdminExceptionType.RowCreate,                ErrorCategory.WriteError },
            { PSAdminExceptionType.RowUpdate,                ErrorCategory.WriteError },
            { PSAdminExceptionType.RowDelete,                ErrorCategory.WriteError },
            { PSAdminExceptionType.ItemExists,               ErrorCategory.ResourceExists },
            { PSAdminExceptionType.QuotaExceeded,            ErrorCategory.QuotaExceeded },
            { PSAdminExceptionType.ItemNotFoundLookup,       ErrorCategory.ObjectNotFound },
            { PSAdminExceptionType.ParameterNotSet,          ErrorCategory.InvalidResult },
            { PSAdminExceptionType.ParameterDefined,         ErrorCategory.InvalidResult },
            { PSAdminExceptionType.CertificatePrivateKey,    ErrorCategory.NotEnabled }
        };
    }
}