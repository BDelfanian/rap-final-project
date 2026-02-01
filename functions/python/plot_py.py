# functions/python/plot_py.py
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def plot_iris_seaborn_box(data: pd.DataFrame) -> plt.Figure:
    """Pure seaborn boxplot by species (polyglot demo)"""
    if not isinstance(data, pd.DataFrame):
        raise TypeError("Input must be a pandas DataFrame")
    
    df_melt = pd.melt(
        data,
        id_vars=['Species'],
        value_vars=data.select_dtypes(include='number').columns,
        var_name='measurement',
        value_name='value'
    )
    
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.boxplot(data=df_melt, x='Species', y='value', hue='measurement', ax=ax)
    ax.set_title('Iris Measurements by Species (Seaborn)')
    plt.tight_layout()
    return fig