'use strict';

// Load the styles
import 'bulma/css/bulma.css';
import './css/index.scss';

import { Elm } from './elm/Main.elm';
import clickoutside from './ClickOutside.js'

clickoutside();

Elm.Main.init({
    node: document.getElementById('root')
});

