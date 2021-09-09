'use strict';

// Load the styles
import './css/index.scss';
import { Elm } from './elm/Main.elm';

Elm.Main.init({
    node: document.getElementById('root')
});

