import * as enhancedResolve from "enhanced-resolve";
import { patchModule } from "./module";

// eslint-disable-next-line @typescript-eslint/no-var-requires
patchModule(enhancedResolve, require("module"));
