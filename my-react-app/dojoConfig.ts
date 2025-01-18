import { createDojoConfig } from "@dojoengine/core";

import manifest from "./contrcat/manifest_dev.json";

export const dojoConfig = createDojoConfig({
    manifest,
});
