{{-- Part of {$package.name.cap$} project. --}}
<?php
/**
 * Global variables
 * --------------------------------------------------------------
 * @var $app      \Windwalker\Web\Application                 Global Application
 * @var $package  \{$package.namespace$}{$package.name.cap$}\{$package.name.cap$}Package                 Package object.
 * @var $view     \Windwalker\Data\Data                       Some information of this view.
 * @var $uri      \Windwalker\Registry\Registry               Uri information, example: $uri['media.path']
 * @var $datetime \DateTime                                   PHP DateTime object of current time.
 * @var $helper   \Windwalker\Core\View\Helper\Set\HelperSet  The Windwalker HelperSet object.
 * @var $router   \Windwalker\Core\Router\PackageRouter       Router object.
 *
 * View variables
 * --------------------------------------------------------------
 * @var $filterBar     \Windwalker\Core\Widget\BladeWidget
 * @var $filterForm    \Windwalker\Form\Form
 * @var $batchForm     \Windwalker\Form\Form
 * @var $showFilterBar boolean
 * @var $grid          \Phoenix\View\Helper\GridHelper
 * @var $state         \Windwalker\Registry\Registry
 * @var $items         \Windwalker\Data\DataSet
 * @var $item          \Windwalker\Data\Data
 * @var $i             integer
 * @var $pagination    \Windwalker\Core\Pagination\Pagination
 */
?>

@extends('_global.{$package.name.lower$}.admin')

@section('toolbar')
    @include('toolbar')
@stop

@section('admin-body')
<div id="phoenix-admin" class="{$controller.list.name.lower$}-container grid-container">
    <form name="admin-form" id="admin-form" action="{{ $router->html('{$controller.list.name.lower$}') }}" method="POST" enctype="multipart/form-data">

        {{-- FILTER BAR --}}
        <div class="filter-bar">
            {!! $filterBar->render(array('form' => $filterForm, 'show' => $showFilterBar)) !!}
        </div>

        {{-- RESPONSIVE TABLE DESC --}}
        <p class="visible-xs-block">
            @translate('phoenix.grid.responsive.table.desc')
        </p>

        <div class="grid-table table-responsive">
            <table class="table table-bordered">
                <thead>
                <tr>
                    {{-- CHECKBOX --}}
                    <th>
                        {!! $grid->checkboxesToggle(array('duration' => 150)) !!}
                    </th>

                    {{-- STATE --}}
                    <th style="min-width: 90px;">
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.state', '{$controller.item.name.lower$}.state') !!}
                    </th>

                    {{-- TITLE --}}
                    <th>
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.title', '{$controller.item.name.lower$}.title') !!}
                    </th>

                    {{-- ORDERING --}}
                    <th width="5%" class="nowrap">
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.ordering', '{$controller.item.name.lower$}.ordering') !!} {!! $grid->saveorderButton() !!}
                    </th>

                    {{-- AUTHOR --}}
                    <th>
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.author', '{$controller.item.name.lower$}.created_by') !!}
                    </th>

                    {{-- CREATED --}}
                    <th>
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.created', '{$controller.item.name.lower$}.created') !!}
                    </th>

                    {{-- LANGUAGE --}}
                    <th>
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.language', '{$controller.item.name.lower$}.language') !!}
                    </th>

                    {{-- ID --}}
                    <th>
                        {!! $grid->sortTitle('{$package.name.lower$}.{$controller.item.name.lower$}.field.id', '{$controller.item.name.lower$}.id') !!}
                    </th>
                </tr>
                </thead>

                <tbody>
                @foreach ($items as $i => $item)
                    <?php
                    $grid->setItem($item, $i);
                    ?>
                    <tr>
                        {{-- CHECKBOX --}}
                        <td>
                            {!! $grid->checkbox() !!}
                        </td>

                        {{-- STATE --}}
                        <td>
                            <span class="btn-group">
                                {!! $grid->published($item->state) !!}
                                <button type="button" class="btn btn-default btn-xs hasTooltip" onclick="Phoenix.Grid.copyRow({{ $i }});"
                                    title="@translate('phoenix.toolbar.duplicate')">
                                    <span class="glyphicon glyphicon-duplicate fa fa-copy text-info"></span>
                                </button>
                                <button type="button" class="btn btn-default btn-xs hasTooltip" onclick="Phoenix.Grid.deleteRow({{ $i }});"
                                    title="@translate('phoenix.toolbar.delete')">
                                    <span class="glyphicon glyphicon-trash fa fa-trash"></span>
                                </button>
                            </span>
                        </td>

                        {{-- TITLE --}}
                        <td>
                            <a href="{{ $router->html('{$controller.item.name.lower$}', array('id' => $item->id)) }}">
                                {{ $item->title }}
                            </a>
                        </td>

                        {{-- ORDERING --}}
                        <td>
                            {!! $grid->orderButton() !!}
                        </td>

                        {{-- AUTHOR --}}
                        <td>
                            {{ $item->created_by }}
                        </td>

                        {{-- CREATED --}}
                        <td>
                            {{ Windwalker\Core\DateTime\DateTime::toLocalTime($item->created) }}
                        </td>

                        {{-- LANGUAGE --}}
                        <td>
                            {{ $item->language }}
                        </td>

                        {{-- ID --}}
                        <td>
                            {{ $item->id }}
                        </td>
                    </tr>
                @endforeach
                </tbody>

                <tfoot>
                <tr>
                    {{-- PAGINATION --}}
                    <td colspan="25">
                        {!! $pagination->render($package->getName() . ':{$controller.list.name.lower$}', 'windwalker.pagination.phoenix') !!}
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>

        <div class="hidden-inputs">
            {{-- METHOD --}}
            <input type="hidden" name="_method" value="PUT" />

            {{-- TOKEN --}}
            {!! \Windwalker\Core\Security\CsrfProtection::input() !!}
        </div>

        @include('batch')
    </form>
</div>
@stop
