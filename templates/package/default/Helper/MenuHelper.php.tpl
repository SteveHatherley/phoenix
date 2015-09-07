<?php
/**
 * Part of phoenix project.
 *
 * @copyright  Copyright (C) 2015 {ORGANIZATION}. All rights reserved.
 * @license    GNU General Public License version 2 or later;
 */

namespace {$package.namespace$}{$package.name.cap$}\Helper;

use Windwalker\Core\Language\Translator;
use Windwalker\Core\View\Helper\AbstractHelper;
use Windwalker\Dom\HtmlElement;
use Windwalker\Filesystem\Filesystem;
use Windwalker\String\StringInflector;

/**
 * The MenuHelper class.
 *
 * @since  {DEPLOY_VERSION}
 */
class MenuHelper extends AbstractHelper
{
	const PLURAL = 'plural';
	const SINGULAR = 'singular';

	/**
	 * active
	 *
	 * @param   string  $name
	 * @param   string  $menu
	 *
	 * @return  string
	 */
	public function active($name, $menu = 'mainmenu')
	{
		$view = $this->getParent()->getView();

		if ($view['app']->get('route.matched') == $view->getPackage()->getName() . ':' . $name)
		{
			return 'active';
		}

		if ($view['app']->get('route.extra.active.' . $menu) == $name)
		{
			return 'active';
		}

		return null;
	}

	/**
	 * getSubmenus
	 *
	 * @return  array
	 */
	public function getSubmenus()
	{
		$menus = $this->findViewMenus(static::PLURAL);
		$view = $this->getParent()->getView();
		$package = $view->getPackage();
		$links = array();

		foreach ($menus as $menu)
		{
			$active = static::active($menu, 'submenu');

			$links[] = new HtmlElement(
				'a',
				Translator::translate($package->getName() . '.' . $menu),
				array(
					'href' => $view->getRouter()->html($menu),
					'class' => $active
				)
			);
		}

		return $links;
	}

	/**
	 * guessSubmenus
	 *
	 * @param string $inflection
	 *
	 * @return array
	 */
	protected function findViewMenus($inflection = self::PLURAL)
	{
		$inflector = StringInflector::getInstance();

		$viewFolder = {$package.name.upper$}_ROOT . '/View';

		$views = Filesystem::folders($viewFolder);
		$menus = array();

		/** @var \SplFileInfo $view */
		foreach ($views as $view)
		{
			if ($view->isFile())
			{
				continue;
			}

			$name = strtolower($view->getBasename());

			if ($inflection == static::PLURAL && $inflector->isPlural($name))
			{
				$menus[] = $name;
			}
			elseif ($inflection == static::SINGULAR && $inflector->isSingular($name))
			{
				$menus[] = $name;
			}
		}

		return $menus;
	}
}
