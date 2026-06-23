import { runApplication } from "elementary-ui-browser-runtime";
import appInit from "virtual:swift-wasm?init";
import "./style.css";

await runApplication(appInit);
