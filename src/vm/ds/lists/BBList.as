/**
 * User: VirtualMaestro
 * Date: 14.02.14
 * Time: 14:50
 */
package vm.ds.lists
{
	import vm.ds.Assert;
	import vm.ds.api.BBNodeList;
	import vm.ds.api.IBBList;
	import vm.ds.api.bbds_namespace;

	use namespace bbds_namespace;

	/**
	 * Implementation of double linked list.
	 *
	 * If need new instance of list use static method 'get' (BBList.get()) instead of 'new' operator.
	 * If need to destroy list use instance's method 'dispose'.
	 */
	public class BBList implements IBBList
	{
		protected var head:BBNodeList;
		protected var tail:BBNodeList;
		private var _size:int = 0;

		bbds_namespace var disposed:Boolean = false;

		/**
		 * Adds object to list (at the tail).
		 */
		public function push(p_obj:Object):BBNodeList
		{
			CONFIG::debug
			{
				Assert.isTrue(!disposed, "List already disposed, impossible to use", "push");
			}

			var node:BBNodeList = BBNodeList.get(p_obj);
			node.list = this;

			if (tail)
			{
				tail.next = node;
				node.prev = tail;
			}
			else head = node;

			tail = node;

			_size++;

			return node;
		}

		/**
		 * Removes object from the list.
		 * Returns 'true' if removing was successful.
		 */
		public function remove(p_obj:Object):Boolean
		{
			CONFIG::debug
			{
				Assert.isTrue(!disposed, "List already disposed, impossible to use", "remove");
			}

			var result:Boolean = false;
			var node:BBNodeList = head;

			while (node)
			{
				if (node.val == p_obj)
				{
					node.dispose();
					result = true;
					break;
				}
			}

			return result;
		}

		/**
		 */
		public function unlink(p_node:BBNodeList):void
		{
			CONFIG::debug
			{
				Assert.isTrue(!disposed, "List already disposed, impossible to use", "unlink");
				Assert.isTrue(p_node.list == this, "Current node isn't linked to this list", "unlink");
			}

			if (p_node == head)
			{
				head = head.next;

				if (head == null) tail = null;
				else head.prev = null;
			}
			else if (p_node == tail)
			{
				tail = tail.prev;

				if (tail == null) head = null;
				else tail.next = null;
			}
			else
			{
				var prevNode:BBNodeList = p_node.prev;
				var nextNode:BBNodeList = p_node.next;
				prevNode.next = nextNode;
				nextNode.prev = prevNode;
			}

			_size--;

			p_node.next = null;
			p_node.prev = null;
			p_node.list = null;
		}

		/**
		 * Returns first node of list.
		 */
		public function get first():BBNodeList
		{
			return head;
		}

		/**
		 * Returns last node of list.
		 */
		public function get last():BBNodeList
		{
			return tail;
		}

		/**
		 * Returns num of elements in list.
		 */
		public function get size():int
		{
			return _size;
		}

		/**
		 * Removes all elements from the list.
		 */
		public function clear():void
		{
			var node:BBNodeList = head;
			var curNode:BBNodeList;

			while (node)
			{
				curNode = node;
				node = node.next;

				curNode.dispose();
			}

			_size = 0;
		}

		/**
		 * Returns 'true' if list already disposed.
		 */
		public function get isDisposed():Boolean
		{
			return disposed;
		}

		/**
		 */
		public function dispose():void
		{
			CONFIG::debug
			{
				Assert.isTrue(!disposed, "List already disposed, impossible to use", "dispose");
			}

			clear();
			disposed = true;
			put(this);
		}

		//*******************
		//***** POOL ********
		//*******************

		static private var _pool:Vector.<BBList> = new <BBList>[];
		static private var _sizePool:int = 0;

		/**
		 * Returns instance of BBNodeList.
		 */
		static public function get():BBList
		{
			var list:BBList;

			if (_sizePool > 0)
			{
				list = _pool[--_sizePool];
				list.disposed = false;
			}
			else list = new BBList();

			return list;
		}

		/**
		 * Put list to pool.
		 */
		static private function put(p_list:BBList):void
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
