// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import DepartmentCategoryController from "controllers/department_category_controller"
application.register("department-category", DepartmentCategoryController)