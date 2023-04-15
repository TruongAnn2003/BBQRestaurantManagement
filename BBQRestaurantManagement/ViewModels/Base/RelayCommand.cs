using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.Base
{
    public class RelayCommand<T> : ICommand
    {

        private readonly Action<T> exeAction;
        private readonly Predicate<T> canExeAction;

        public RelayCommand(Action<T> exeAction)
        {
            this.exeAction = exeAction;
            canExeAction = null;
        }

        public RelayCommand(Action<T> exeAction, Predicate<T> canExeAction)
        {
            this.exeAction = exeAction;
            this.canExeAction = canExeAction;
        }

        public event EventHandler CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }

        public bool CanExecute(object parameter)
        {
            try
            {
                return canExeAction == null ? true : canExeAction((T)parameter);
            }
            catch
            {
                return true;
            }
        }

        public void Execute(object parameter)
        {
            exeAction((T)parameter);
        }
    }
}
