import * as enhancedResolve from 'enhanced-resolve';
import { patchModule } from './module';

patchModule(enhancedResolve, require('module'));
