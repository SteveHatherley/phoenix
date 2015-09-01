{{-- Part of phoenix project. --}}

<div class="form-group">
    <?php
    $field->set('class', $field->get('class') . ' form-control');
    $field->set('labelClass', $field->get('labelClass') . ' control-label ' . $field->get('labelWidth', 'col-md-3'));
    ?>
    {{ $field->renderLabel() }}

    <div class="{{ $field->get('fieldWidth', 'col-md-9') }}">
    <?php
    $radios = $field->renderInput();
    \Windwalker\Test\TestHelper::invoke($radios, 'prepareOptions');
    ?>
    @foreach($radios->getContent() as $option)
        <div class="radio">
            {{ $option[0]->setAttribute('style', 'margin-left: 0;') }}
            {{ $option[1] }}
        </div>
    @endforeach
    </div>
</div>