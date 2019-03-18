using System;
using PSAdmin.Internal;
using System.Management.Automation;

namespace PSAdmin.PowerShell.Commands {

    /// <summary>
    /// Returns the thread's current UI culture.
    /// </summary>
    [Cmdlet(VerbsCommon.Open, "PSAdmin", DefaultParameterSetName = ConnectionStringParameterSetName)]
    [OutputType(typeof(System.String))]
    public sealed class OpenPSAdmin : PSCmdlet
    {
        private const string ConnectionStringParameterSetName = "ConnectionStringParameterSetName";

        /// <summary>
        /// Specify a ConnectionString to access a SQL/SQLite Back end
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = ConnectionStringParameterSetName)]
        public string SQLConnectionString { get; set; }

        /// <summary>
        /// Verify is local Database
        /// </summary>
        [Parameter(ParameterSetName = ConnectionStringParameterSetName)]
        public SwitchParameter IsLocalDatabase { get; set; }

        /// <summary>
        /// Begin output
        /// </summary>
        protected override void BeginProcessing()
        {
            switch (ParameterSetName)
            {
                case ConnectionStringParameterSetName:
                    WriteVerbose(string.Format("Writing SQLConnectionString: {0}", SQLConnectionString ));
                    bool IsValid = SQLiteDB.ValidateConnectionString(SQLConnectionString);
                    if (!IsValid) {

                        ArgumentException exception = new System.ArgumentException(
                            String.Format("Argument is not a correct syntax\nValue: {0}", SQLConnectionString),
                            "SQLConnectionString"
                        );
                        ErrorRecord errorRecord = new ErrorRecord(exception, "ErrorId", ErrorCategory.InvalidArgument, null);
                        ThrowTerminatingError(errorRecord);
                    }

                    Config.SQLConnectionString = SQLConnectionString;
                    Config.IsLocalDatabase = IsLocalDatabase;
                    break;
                    
            }

        }

    }
}