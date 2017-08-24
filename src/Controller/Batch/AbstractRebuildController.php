<?php
/**
 * Part of earth project.
 *
 * @copyright  Copyright (C) 2016 LYRASOFT. All rights reserved.
 * @license    GNU General Public License version 2 or later.
 */

namespace Phoenix\Controller\Batch;

use Windwalker\Core\Frontend\Bootstrap;
use Windwalker\Core\Language\Translator;
use Windwalker\Core\Security\Exception\UnauthorizedException;
use Windwalker\Data\Data;
use Windwalker\Record\NestedRecord;

/**
 * The AbstractRebuildController class.
 *
 * @since  1.1
 */
class AbstractRebuildController extends AbstractBatchController
{
	/**
	 * Property action.
	 *
	 * @var  string
	 */
	protected $action = 'rebuild';

	/**
	 * doExecute
	 *
	 * @return mixed
	 * @throws \Exception
	 */
	protected function doExecute()
	{
		if (!$this->checkAccess([]))
		{
			throw new UnauthorizedException('You have no access to modify this resource.');
		}

		try
		{
			/** @var NestedRecord $record */
			$record = $this->model->getRecord();

			$record->rebuild();

			$ids = $this->model->getDataMapper()->findColumn('id', ['parent_id != 0']);

			foreach ($ids as $id)
			{
				$record->rebuildPath($id);
			}
		}
		catch (\Exception $e)
		{
			if (WINDWALKER_DEBUG)
			{
				throw $e;
			}

			$this->addMessage($e->getMessage(), Bootstrap::MSG_DANGER);
			$this->setRedirect($this->getFailRedirect());

			return false;
		}

		$this->addMessage($this->getSuccessMessage(), Bootstrap::MSG_SUCCESS);
		$this->setRedirect($this->getSuccessRedirect());

		return true;
	}

	/**
	 * getSuccessMessage
	 *
	 * @param Data $data
	 *
	 * @return  string
	 */
	public function getSuccessMessage($data = null)
	{
		return Translator::translate($this->langPrefix . 'message.batch.' . $this->action . '.success');
	}
}
