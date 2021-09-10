'use strict';

// Load the styles
import 'bulma/css/bulma.css';
import './css/index.scss';

import { Elm } from './elm/Main.elm';

Elm.Main.init({
    node: document.getElementById('root')
});

