<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__);

return (new PhpCsFixer\Config())
    ->setRules([
        'single_blank_line_at_eof' => true,
    ])
    ->setFinder($finder);
