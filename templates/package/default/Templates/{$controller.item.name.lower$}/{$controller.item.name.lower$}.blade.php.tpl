{{-- Part of {$package.name.cap$} project. --}}
<?php
/**
 * Global variables
 * --------------------------------------------------------------
 * @var $app      \Windwalker\Web\Application                 Global Application
 * @var $package  \Windwalker\Core\Package\AbstractPackage    Package object.
 * @var $view     \Windwalker\Data\Data                       Some information of this view.
 * @var $uri      \Windwalker\Uri\UriData                     Uri information, example: $uri->path
 * @var $datetime \Windwalker\Core\DateTime\DateTime          PHP DateTime object of current time.
 * @var $helper   \Windwalker\Core\View\Helper\Set\HelperSet  The Windwalker HelperSet object.
 * @var $router   \Windwalker\Core\Router\MainRouter          Route builder object.
 * @var $asset    \Windwalker\Core\Asset\AssetManager         The Asset manager.
 *
 * View variables
 * --------------------------------------------------------------
 * @var $item  \{$package.namespace$}{$package.name.cap$}\Record\{$controller.item.name.cap$}Record
 * @var $state \Windwalker\Structure\Structure
 * @var $form  \Windwalker\Form\Form
 */
?>

@extends('_global.{$package.name.lower$}.admin')

@section('toolbar-buttons')
    @include('toolbar')
@stop

@section('admin-body')
<form name="admin-form" id="admin-form" action="{{ $router->route('{$controller.item.name.lower$}', array('id' => $item->id)) }}" method="POST" enctype="multipart/form-data">

    <div class="row">
        <div class="col-md-7">
            <fieldset class="form-horizontal">
                <legend>@translate('{$package.name.lower$}.{$controller.item.name.lower$}.edit.fieldset.basic')</legend>

                {!! $form->renderFields('basic') !!}
            </fieldset>

            <fieldset class="form-horizontal">
                <legend>@translate('{$package.name.lower$}.{$controller.item.name.lower$}.edit.fieldset.text')</legend>

                {!! $form->renderFields('text') !!}
            </fieldset>
        </div>
        <div class="col-md-5">
            <fieldset class="form-horizontal">
                <legend>@translate('{$package.name.lower$}.{$controller.item.name.lower$}.edit.fieldset.created')</legend>

                {!! $form->renderFields('created') !!}
            </fieldset>
        </div>
    </div>

    <div class="hidden-inputs">
        @formToken()
    </div>

</form>
@stop
