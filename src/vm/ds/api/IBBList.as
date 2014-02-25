/**
 * User: VirtualMaestro
 * Date: 14.02.14
 * Time: 14:27
 */
package vm.ds.api
{
	/**
	 * Interface for list and all based on list data structure.
	 */
	public interface IBBList
	{
		function push(p_obj:Object):BBNodeList;
		function remove(p_obj:Object):Boolean;
		function unlink(p_node:BBNodeList):void;
		function clear():void;
		function get isDisposed():Boolean;
		function get size():int;
		function dispose():void;
	}
}
