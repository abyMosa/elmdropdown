'use strict';

// Load the styles
import './css/index.scss';
import 'bulma/css/bulma.css';

import { Elm } from './elm/Main.elm';

Elm.Main.init({
    node: document.getElementById('root')
});

