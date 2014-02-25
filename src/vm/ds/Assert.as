package vm.ds
{
	/**
	 */
	public class Assert
	{
		static public function isTrue(p_expression:Boolean, p_message:String = "", p_whereOccur:String = ""):void
		{
			if (!p_expression)
			{
				if (p_message == "" || p_message == null)
				{
					p_message = "[Assertion failed] - this expression must be true";
				}
				else
				{
					if (p_whereOccur != "") p_message = "ERROR: in " + p_whereOccur + ": " + p_message + "!";
					else p_message = "ERROR: " + p_message + "!";
				}

				throw new Error(p_message);
			}
		}
	}
}
