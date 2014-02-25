/**
 * User: VirtualMaestro
 * Date: 14.02.14
 * Time: 14:34
 */
package vm.ds.api
{
	use namespace bbds_namespace;

	/**
	 */
	final public class BBNodeList
	{
		public var next:BBNodeList;
		public var prev:BBNodeList;
		public var val:Object;
		bbds_namespace var list:IBBList;

		/**
		 */
		public function BBNodeList(p_obj:Object)
		{
			val = p_obj;
		}

		/**
		 * Unlink node from its list.
		 */
		[Inline]
		public function unlink():void
		{
			if (list) list.unlink(this);
		}

		/**
		 * Check if node linked to list now.
		 */
		[Inline]
		public function get isLinked():Boolean
		{
			return list != null;
		}

		/**
		 * Disposing the node.
		 * If node in list now, unlink it from the list, nullify all references and push it to pool.
		 */
		public function dispose():void
		{
			unlink();
			val = null;

			put(this);
		}

		//*******************
		//***** POOL ********
		//*******************

		static private var _pool:Vector.<BBNodeList> = new <BBNodeList>[];
		static private var _size:int = 0;

		/**
		 * Returns instance of BBNodeList.
		 */
		static public function get(p_object:Object = null):BBNodeList
		{
			var node:BBNodeList;

			if (_size > 0)
			{
				node = _pool[--_size];
				node.val = p_object;
			}
			else node = new BBNodeList(p_object);

			return node;
		}

		/**
		 * Put node to pool.
		 */
		static private function put(p_node:BBNodeList):void
		{
			_pool[_size++] = p_node;
		}

		/**
		 * Clear pool of nodes.
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
