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
 * @var $item  \Windwalker\Data\Data
 * @var $state \Windwalker\Registry\Registry
 * @var $form  \Windwalker\Form\Form
 */
?>

@extends('_global.{$package.name.lower$}.admin-edit')

@section('toolbar')
    @include('toolbar')
@stop

@section('admin-body')
<form name="admin-form" id="admin-form" action="{{ $route->encode('{$controller.item.name.lower$}', array('id' => $item->id)) }}" method="POST" enctype="multipart/form-data">

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
        {!! \Windwalker\Core\Security\CsrfProtection::input() !!}
    </div>

</form>
@stop