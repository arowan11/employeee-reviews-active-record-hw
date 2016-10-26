require './db_connection'
require './employee'

class Department < ActiveRecord::Base

  def add_employee(new_employee)
    new_employee.department_id = self.id
    new_employee.save
  end

  def department_salary
    staff = all_employees.to_a
    staff.reduce(0.0) {|sum, e| sum + e.salary}
  end

  # def add_employee_review(review)
  #   @review = review
  # end

  def department_raise(alloted_amount)
    raise_eligible = all_employees.select {|e| yield(e)}.to_a
    amount = alloted_amount / raise_eligible.length
    raise_eligible.each { |e| e.raise_by_amount(amount) }
  end

  def all_employees
    Employee.where(department_id: self.id)
  end

  def least_paid_employee
    all_employees.order(salary: :asc).first
  end

  def employees_sorted_alphabetically
    all_employees.order(name: :asc)
  end

  def average_employee_salary
    department_salary / all_employees.size
  end

  def employees_paid_above_average
    all_employees.select { |e| e.salary > average_employee_salary }
  end
end
