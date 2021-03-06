<?php
/**
 * Part of Phoenix project.
 *
 * @copyright  Copyright (C) 2016 LYRASOFT. All rights reserved.
 * @license    GNU General Public License version 2 or later.
 */

namespace Phoenix\Controller\Batch;

use Phoenix\Controller\AbstractPostController;
use Windwalker\Core\Language\Translator;
use Windwalker\Core\Model\Exception\ValidateFailException;
use Windwalker\Core\Model\ModelRepository;
use Windwalker\Core\Security\Exception\UnauthorizedException;
use Windwalker\Data\Data;
use Windwalker\Data\DataInterface;
use Windwalker\Record\Exception\NoResultException;

/**
 * The AbstractBatchController class.
 *
 * @see  BatchDelegatingController
 *
 * @since  1.0.5
 */
abstract class AbstractBatchController extends AbstractPostController
{
	/**
	 * Property action.
	 *
	 * @var  string
	 */
	protected $action = 'batch';

	/**
	 * Property inflection.
	 *
	 * @var  string
	 */
	protected $inflection = self::PLURAL;

	/**
	 * Property allowNullData.
	 *
	 * @var  boolean
	 */
	protected $allowNullData = false;

	/**
	 * Property cid.
	 *
	 * @var  array
	 */
	protected $pks = [];

	/**
	 * Property emptyMark.
	 *
	 * @var  string
	 */
	protected $emptyMark = '__EMPTY__';

	/**
	 * A hook before main process executing.
	 *
	 * @return  void
	 */
	protected function prepareExecute()
	{
		parent::prepareExecute();

		$this->pks = (array) $this->input->getArray($this->keyName, $this->input->getArray('id'));
	}

	/**
	 * save
	 *
	 * @param   string|int    $pk
	 * @param   DataInterface $data
	 *
	 * @return  DataInterface
	 *
	 * @throws NoResultException
	 * @throws ValidateFailException
	 * @throws \UnexpectedValueException
	 * @throws \LogicException
	 * @throws \InvalidArgumentException
	 * @throws \RuntimeException
	 */
	protected function save($pk, DataInterface $data)
	{
		$data->{$this->keyName} = $pk;

		return $this->model->save($data);
	}

	/**
	 * doExecute
	 *
	 * @return bool[]
	 * @throws \Exception
	 */
	protected function doExecute()
	{
		$data = new Data($this->data);

		$data = $this->cleanData($data);

		if (!$this->checkAccess($this->dataObject))
		{
			throw new UnauthorizedException('You have no access to modify these items.');
		}

		if ($data->isNull() && !$this->allowNullData)
		{
			throw new ValidateFailException(Translator::translate('phoenix.message.batch.data.empty'));
		}

		if (count($this->pks) < 1)
		{
			throw new ValidateFailException(Translator::translate($this->langPrefix . 'message.batch.item.empty'));
		}

		$this->validate($data);

		$this->preSave($data);

		$results = [];

		foreach ((array) $this->pks as $pk)
		{
			if (!$this->checkItemAccess($pk, $data))
			{
				$results[$pk] = false;
				continue;
			}

			if (!$this->validateItem($pk, $data))
			{
				$results[$pk] = false;
				continue;
			}

			$this->save($pk, clone $data);

			$results[$pk] = true;
		}

		$this->postSave($data);

		return $results;
	}

	/**
	 * validateItem
	 *
	 * @param int           $pk
	 * @param DataInterface $data
	 *
	 * @return  bool
	 *
	 * @throws ValidateFailException
	 */
	protected function validateItem($pk, DataInterface $data)
	{
		return true;
	}

	/**
	 * checkItemAccess
	 *
	 * @param int           $pk
	 * @param DataInterface $data
	 *
	 * @return  bool
	 *
	 * @throws \RuntimeException
	 */
	protected function checkItemAccess($pk, DataInterface $data)
	{
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
		return Translator::plural($this->langPrefix . 'message.batch.' . $this->action . '.success', count($this->pks), count($this->pks));
	}

	/**
	 * preSave
	 *
	 * @param DataInterface $data
	 *
	 * @return  void
	 */
	protected function preSave(DataInterface $data)
	{
		// Do some stuff
	}

	/**
	 * postSave
	 *
	 * @param DataInterface $data
	 *
	 * @return  void
	 */
	protected function postSave(DataInterface $data)
	{
		// Do some stuff
	}

	/**
	 * cleanData
	 *
	 * @param DataInterface $data
	 *
	 * @return  DataInterface
	 */
	protected function cleanData(DataInterface $data)
	{
		// Remove empty data
		foreach ($data as $k => $value)
		{
			if ((string) $value === '')
			{
				unset($data[$k]);
			}
			elseif ($value === $this->emptyMark)
			{
				$data[$k] = '';
			}
			elseif ($value === '\\' . $this->emptyMark)
			{
				$data[$k] = $this->emptyMark;
			}
		}

		return $data;
	}

	/**
	 * validate
	 *
	 * @param DataInterface $data
	 *
	 * @return  void
	 *
	 * @throws  ValidateFailException
	 */
	protected function validate(DataInterface $data)
	{
		// Do some stuff
	}

	/**
	 * getModel
	 *
	 * @param string $name
	 * @param mixed  $source
	 * @param bool   $forceNew
	 *
	 * @return ModelRepository
	 *
	 * @throws \DomainException
	 */
	public function getModel($name = null, $source = null, $forceNew = false)
	{
		// Force the singular model
		if ($name === null && !$this->model instanceof ModelRepository)
		{
			if (is_string($this->model))
			{
				$name = $this->model;
			}
			else
			{
				$name = $name ? : $this->config['item_name'];
			}
		}

		return parent::getModel($name, $source, $forceNew);
	}
}
