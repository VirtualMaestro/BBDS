/**
 * User: VirtualMaestro
 * Date: 14.02.14
 * Time: 18:03
 */
package vm.ds.stacks
{
	import vm.ds.Assert;
	import vm.ds.api.BBNodeList;
	import vm.ds.api.bbds_namespace;
	import vm.ds.lists.BBList;

	use namespace bbds_namespace;

	/**
	 * Implementation of stack structure based on double linked list.
	 */
	public class BBStack extends BBList
	{
		/**
		 * Returns top element.
		 * Element doesn't remove from the stack.
		 */
		public function get top():Object
		{
			return tail ? tail.val : null;
		}

		/**
		 * Returns top element of stack and remove from it.
		 */
		public function pop():Object
		{
			var obj:Object;
			var node:BBNodeList = tail;

			if (node)
			{
				obj = node.val;
				node.dispose();
			}

			return obj;
		}

		/**
		 */
		override public function dispose():void
		{
			CONFIG::debug
			{
				Assert.isTrue(!disposed, "Stack already disposed, impossible to use", "dispose");
			}

			clear();
			disposed = true;
			put(this);
		}

		//*******************
		//***** POOL ********
		//*******************

		static private var _pool:Vector.<BBStack> = new <BBStack>[];
		static private var _sizePool:int = 0;

		/**
		 * Returns instance of BBNodeList.
		 */
		static public function get():BBStack
		{
			var list:BBStack;

			if (_sizePool > 0)
			{
				list = _pool[--_sizePool];
				list.disposed = false;
			}
			else list = new BBStack();

			return list;
		}

		/**
		 * Put list to pool.
		 */
		static private function put(p_list:BBStack):void
		{
			_pool[_sizePool++] = p_list;
		}

		/**
		 * Clear pool of lists.
		 */
		static public function rid():void
		{
			var len:int = _pool.length;
			for (var i:int = 0; i < len; i++)
			{
				_pool[i] = null;
			}

			_pool.length = 0;
		}
	}
}
