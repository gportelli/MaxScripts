struct TFBT_Utils
(
	private

	fn _disableProcessWindowsGhosting =
    (
		local source = StringStream ("using System.Runtime.InteropServices; public class DisableWindowsGhosting{ [DllImport(\"user32.dll\")]  public static extern bool DisableProcessWindowsGhosting();  }")

		compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
		compilerParams.ReferencedAssemblies.Add("System.dll");
		compilerParams.GenerateInMemory = on
		csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
		compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source as String)
		flush source
		close source
		if (compilerResults.Errors.Count > 0 ) then
		(
			local errs = stringstream ""
			for i = 0 to (compilerResults.Errors.Count-1) do
			(
				local err = compilerResults.Errors.Item[i]
				format "Error:% Line:% Column:% %\n" err.ErrorNumber err.Line err.Column err.ErrorText to:errs
			)
			format "%\n" errs
			undefined
		)
		else
		(
			compilerResults.CompiledAssembly.CreateInstance "DisableWindowsGhosting"
		)
    ),

	public

	fn DisableProcessWindowsGhosting =
    (
		DisableWindowsGhosting = _disableProcessWindowsGhosting()
		DisableWindowsGhosting.DisableProcessWindowsGhosting()
	)
)